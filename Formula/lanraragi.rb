require "language/node"

class Lanraragi < Formula
  desc "Web application for archival and reading of manga/doujinshi"
  homepage "https://github.com/Difegue/LANraragi"
  url "https://github.com/Difegue/LANraragi/archive/v.0.8.90.tar.gz"
  sha256 "290bd2299962f14667a279dd8e40a1f93d1e9e338c08342af5830a1ce119c93e"
  license "MIT"
  head "https://github.com/Difegue/LANraragi.git", branch: "dev"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "02799489c4bc1e48ae5c56b9a472d1148515b632be58d47280671a57a2a30c39"
    sha256 cellar: :any,                 arm64_monterey: "d8a459c8954977fc7bc35b6103bfa5c62b672ac8dc3bfc346c360857ad0a25d1"
    sha256 cellar: :any,                 arm64_big_sur:  "5eb21bf1fcb7183398dbc76228795c4e3d7bcc0e2944659ba0cd3a70eacba518"
    sha256 cellar: :any,                 ventura:        "5e60860f4f869269ce7b504ce88b8d59f2d9032123820007c9ae1bbe0cccdda0"
    sha256 cellar: :any,                 monterey:       "d800ed9911450346777fa69f6fe69fbb0bc0be84decb56df9cb7ef25a12ef1e9"
    sha256 cellar: :any,                 big_sur:        "4d37418181606aa314ae1f85a9777f8b108ab393179adcfeca0d7697bb3c3121"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac77cee4270fa19b961449d101ff9a7fc8e16a95255f4883e8c38bdc5aecdfc8"
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
  depends_on "openssl@1.1"
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

    ENV["OPENSSL_PREFIX"] = Formula["openssl@1.1"].opt_prefix

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
