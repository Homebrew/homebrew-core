require "language/node"

class Lanraragi < Formula
  desc "Web application for archival and reading of manga/doujinshi"
  homepage "https://github.com/Difegue/LANraragi"
  url "https://github.com/Difegue/LANraragi/archive/v.0.7.6.tar.gz"
  sha256 "2c498cc6a18b9fbb77c52ca41ba329c503aa5d4ec648075c3ebb72bfa7102099"
  license "MIT"
  revision 1
  head "https://github.com/Difegue/LANraragi.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "fb0c87e940a7cc1575c7125d983b468ed7ff1564ac2c448fc70c30c5920c1189"
    sha256 cellar: :any, big_sur:       "107ca8fb3207f324b61f7115019512c8a93280cbd8f16d60df2838d6ae8fbe44"
    sha256 cellar: :any, catalina:      "a35ce1425f35485335912860dbf0276dd429b7091ee1166ad9b68828dc2a79b5"
    sha256 cellar: :any, mojave:        "ed87a8d37fdb8a48cf537bd3483b42e58f3c8517abf513f9f3f1b575e1236152"
  end

  depends_on "pkg-config" => :build
  depends_on "cpanminus"
  depends_on "ghostscript"
  depends_on "giflib"
  depends_on "imagemagick@6"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "node"
  depends_on "openssl@1.1"
  depends_on "perl"
  depends_on "redis"
  uses_from_macos "libarchive"

  resource "Image::Magick" do
    url "https://cpan.metacpan.org/authors/id/J/JC/JCRISTY/PerlMagick-6.9.11.tar.gz"
    sha256 "3af99fb4625fe6c7ccb55c79709afe31df4af66886a35e5c5a494507a0814061"
  end

  resource "IO::Socket::SSL" do
    url "https://cpan.metacpan.org/authors/id/S/SU/SULLR/IO-Socket-SSL-2.069.tar.gz"
    sha256 "d83c2cae5e8a22ab49c9f2d964726625e9efe56490d756a48a7b149a3d6e278d"
  end

  resource "libarchive-headers" do
    url "https://opensource.apple.com/tarballs/libarchive/libarchive-83.40.4.tar.gz"
    sha256 "20ad61b1301138bc7445e204dd9e9e49145987b6655bbac39f6cad3c75b10369"
  end

  resource "Archive::Peek::Libarchive" do
    url "https://cpan.metacpan.org/authors/id/R/RE/REHSACK/Archive-Peek-Libarchive-0.38.tar.gz"
    sha256 "332159603c5cd560da27fd80759da84dad7d8c5b3d96fbf7586de2b264f11b70"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", "#{libexec}/lib/perl5"
    ENV.prepend_path "PERL5LIB", "#{libexec}/lib"
    ENV["CFLAGS"] = "-I#{libexec}/include"

    imagemagick = Formula["imagemagick@6"]
    resource("Image::Magick").stage do
      inreplace "Makefile.PL" do |s|
        s.gsub! "/usr/local/include/ImageMagick-#{imagemagick.version.major}",
                "#{imagemagick.opt_include}/ImageMagick-#{imagemagick.version.major}"
      end

      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make"
      system "make", "install"
    end

    resource("IO::Socket::SSL").stage do
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make", "install"
    end

    resource("libarchive-headers").stage do
      cd "libarchive/libarchive" do
        (libexec/"include").install "archive.h", "archive_entry.h"
      end
    end

    resource("Archive::Peek::Libarchive").stage do
      inreplace "Makefile.PL" do |s|
        s.gsub! "$autoconf->_get_extra_compiler_flags", "$autoconf->_get_extra_compiler_flags .$ENV{CFLAGS}"
      end

      system "cpanm", "Config::AutoConf", "--notest", "-l", libexec
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make"
      system "make", "install"
    end

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
    # This can't have its _user-facing_ functionality tested in the `brew test`
    # environment because it needs Redis. It fails spectacularly tho with some
    # table flip emoji. So let's use those to confirm _some_ functionality.
    output = <<~EOS
      ｷﾀ━━━━━━(ﾟ∀ﾟ)━━━━━━!!!!!
      (╯・_>・）╯︵ ┻━┻
      It appears your Redis database is currently not running.
      The program will cease functioning now.
    EOS
    assert_match output, shell_output("#{bin}/lanraragi", 1)
  end
end
