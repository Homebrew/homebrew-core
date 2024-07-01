require "language/node"

class Lanraragi < Formula
  desc "Web application for archival and reading of manga/doujinshi"
  homepage "https://github.com/Difegue/LANraragi"
  url "https://github.com/Difegue/LANraragi/archive/refs/tags/v.0.9.10.tar.gz"
  sha256 "03d00928a84705e7b89a667c6aea85b529ca1d1c08a153e0c2e2922ec64fd0d1"
  license "MIT"
  revision 1
  head "https://github.com/Difegue/LANraragi.git", branch: "dev"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "80a79b140793a3a5ccf020fd0424c409516008a3d2fc792df709d28c21ff647f"
    sha256 cellar: :any,                 arm64_ventura:  "ba0e853e04297c1e1e17108478b25955a8d44f50b1d93a1252bcbf95aa372370"
    sha256 cellar: :any,                 arm64_monterey: "ee17141271cc1b784fbfb3fcab13365a593d2638c2c79cce39db09103d4fa8e2"
    sha256 cellar: :any,                 sonoma:         "53e1105e464caf48d2415dc1a72906b5ca0269bba802ee74c2a229a2338052ec"
    sha256 cellar: :any,                 ventura:        "c01bccd2a47abe5eb01dfb81c1462cdc2212a8797978e8c8ac5bdc174d00eff8"
    sha256 cellar: :any,                 monterey:       "bfe35ab57f4cb2257dca6079a07a34e2e4cccbb0ed45635ca5b21909806d9e8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2daa2c275346d68bdddf3368e47e5d93a6568a915caa99fc5acdf78769724b0"
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
      url "https://github.com/apple-oss-distributions/libarchive/archive/refs/tags/libarchive-131.tar.gz"
      sha256 "8d0e4d71d2b039a968d2c7b4230806912785da98ce5d3a10c60024016ac343bb"
    end
  end

  resource "Image::Magick" do
    url "https://cpan.metacpan.org/authors/id/J/JC/JCRISTY/Image-Magick-7.1.1-28.tar.gz"
    sha256 "bc54137346c1d45626e7075015f7d1dae813394af885457499f54878cfc19e0b"
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
