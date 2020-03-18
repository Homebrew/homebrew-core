require "language/node"

class Lanraragi < Formula
  desc "Web application for archival and reading of manga/doujinshi. Lightweight and Docker-ready for NAS/servers."
  homepage "https://github.com/Difegue/LANraragi"
  url "https://github.com/Difegue/LANraragi/archive/v.0.6.9-homebrew.tar.gz"
  sha256 "fa915fa3251e6c0edb1bbea37cb910efeef5092dfc8f919b5123cf644ca5a454"
  head "https://github.com/Difegue/LANraragi.git"

  depends_on "pkg-config" => :build
  depends_on "cpanminus"
  depends_on "giflib"
  depends_on "imagemagick@6"
  depends_on "jpeg"
  depends_on "libarchive"
  depends_on "libpng"
  depends_on "node"
  depends_on "openssl"
  depends_on "perl"
  depends_on "redis"


  resource "Image::Magick" do
    url "https://cpan.metacpan.org/authors/id/J/JC/JCRISTY/PerlMagick-6.89-1.tar.gz"
    sha256 "c8f81869a4f007be63e67fddf724b23256f6209f16aa95e14d0eaef283772a59"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    ENV.prepend_path "PERL5LIB", libexec/"lib"

    resource("Image::Magick").stage do
      inreplace "Makefile.PL" do |s|
        s.gsub! "include/ImageMagick-6", "opt/imagemagick@6/include/ImageMagick-6"
      end

      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make"
      system "make", "install"
    end

    system "npm", "install", *Language::Node.local_npm_install_args
    system "perl", "./tools/install.pl", "install-full"

    prefix.install "README.md"
    bin.install "tools/build/homebrew/lanraragi"
    (libexec/"lib").install Dir["lib/*"]
    libexec.install "script"
    libexec.install "package.json"
    libexec.install "public"
    libexec.install "templates"
    libexec.install "tests"
    libexec.install "tools/build/homebrew/redis.conf"
    libexec.install "lrr.conf"
  end

  test do
    ENV["PERL5LIB"] = libexec/"lib/perl5"
    ENV["LRR_LOG_DIRECTORY"] = testpath/"log"

    system "npm", "--prefix", prefix, "test"
  end
end
