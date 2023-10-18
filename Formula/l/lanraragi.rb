require "language/node"

class Lanraragi < Formula
  desc "Web application for archival and reading of manga/doujinshi"
  homepage "https://github.com/Difegue/LANraragi"
  url "https://github.com/Difegue/LANraragi/archive/v.0.8.90.tar.gz"
  sha256 "290bd2299962f14667a279dd8e40a1f93d1e9e338c08342af5830a1ce119c93e"
  license "MIT"
  revision 2
  head "https://github.com/Difegue/LANraragi.git", branch: "dev"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6d7cecbd0f38afed3ee880deca03e8aee23cc18f4d7fb51657d0a0e8e9bd80b6"
    sha256 cellar: :any,                 arm64_ventura:  "6ac4aa61abe98f69a42b73b465e8928fa7c06d3933f023fddc2690ad588af4d5"
    sha256 cellar: :any,                 arm64_monterey: "aec9003288a39616f378a570a1e13b26dc299061f2f436e0d83b18365dd6cc9f"
    sha256 cellar: :any,                 sonoma:         "6c1d39363d02694aa3ad570371eef0a7866974629d0cda89edbd1fdea93b9607"
    sha256 cellar: :any,                 ventura:        "2c8e3c4d10539a00006d61e1dd76c8263fcb91cf51d071e356c250117889cdf2"
    sha256 cellar: :any,                 monterey:       "708cdbb45a1da8b23ca91564568ec0b451b10911f2b4ff70d1a66d37e69e14d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e9a46d6556104ff0c6039b1fee385acaa23a344a095bd956d8816c1cfad267c"
  end

  depends_on "nettle" => :build
  depends_on "pkg-config" => :build
  depends_on "cpanminus"
  depends_on "ghostscript"
  depends_on "giflib"
  depends_on "imagemagick"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "node"
  depends_on "openssl@3"
  depends_on "perl"
  depends_on "redis"
  depends_on "zstd"

  uses_from_macos "libarchive"

  resource "libarchive-headers" do
    on_macos do
      url "https://github.com/apple-oss-distributions/libarchive/archive/refs/tags/libarchive-113.tar.gz"
      sha256 "b422c37cc5f9ec876d927768745423ac3aae2d2a85686bc627b97e22d686930f"
    end
  end

  resource "Image::Magick" do
    url "https://cpan.metacpan.org/authors/id/J/JC/JCRISTY/Image-Magick-7.1.0-0.tar.gz"
    sha256 "f90c975cbe21445777c40d19c17b7f79023d3064ef8fabcf348cf82654bc16eb"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", "#{libexec}/lib/perl5"
    ENV.prepend_path "PERL5LIB", "#{libexec}/lib"

    # On Linux, use the headers provided by the libarchive formula rather than the ones provided by Apple.
    ENV["CFLAGS"] = if OS.mac?
      "-I#{libexec}/include"
    else
      "-I#{Formula["libarchive"].opt_include}"
    end

    ENV["OPENSSL_PREFIX"] = Formula["openssl@3"].opt_prefix

    imagemagick = Formula["imagemagick"]
    resource("Image::Magick").stage do
      inreplace "Makefile.PL" do |s|
        s.gsub! "/usr/local/include/ImageMagick-#{imagemagick.version.major}",
                "#{imagemagick.opt_include}/ImageMagick-#{imagemagick.version.major}"
      end

      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make"
      system "make", "install"
    end

    if OS.mac?
      resource("libarchive-headers").stage do
        cd "libarchive/libarchive" do
          (libexec/"include").install "archive.h", "archive_entry.h"
        end
      end
    end

    system "cpanm", "Config::AutoConf", "--notest", "-l", libexec
    system "npm", "install", *Language::Node.local_npm_install_args
    system "perl", "./tools/install.pl", "install-full"

    prefix.install "README.md"
    (libexec/"lib").install Dir["lib/*"]
    libexec.install "script", "package.json", "public", "templates", "tests", "lrr.conf"
    cd "tools/build/homebrew" do
      bin.install "lanraragi"
      libexec.install "redis.conf"
    end
  end

  def caveats
    <<~EOS
      Automatic thumbnail generation will not work properly on macOS < 10.15 due to the bundled Libarchive being too old.
      Opening archives for reading will generate thumbnails normally.
    EOS
  end

  test do
    # Make sure lanraragi writes files to a path allowed by the sandbox
    ENV["LRR_LOG_DIRECTORY"] = ENV["LRR_TEMP_DIRECTORY"] = testpath
    %w[server.pid shinobu.pid minion.pid].each { |file| touch file }

    # Set PERL5LIB as we're not calling the launcher script
    ENV["PERL5LIB"] = libexec/"lib/perl5"

    # This can't have its _user-facing_ functionality tested in the `brew test`
    # environment because it needs Redis. It fails spectacularly tho with some
    # table flip emoji. So let's use those to confirm _some_ functionality.
    output = <<~EOS
      ｷﾀ━━━━━━(ﾟ∀ﾟ)━━━━━━!!!!!
      (╯・_>・）╯︵ ┻━┻
      It appears your Redis database is currently not running.
      The program will cease functioning now.
    EOS
    # Execute through npm to avoid starting a redis-server
    return_value = OS.mac? ? 61 : 111
    assert_match output, shell_output("npm start --prefix #{libexec}", return_value)
  end
end
