require "language/node"

class Lanraragi < Formula
  desc "Web application for archival and reading of manga/doujinshi. Lightweight and Docker-ready for NAS/servers."
  homepage "https://github.com/Difegue/LANraragi"
  version "0.6.6"
  url "https://github.com/Difegue/LANraragi/archive/v.0.6.6.tar.gz"
  sha256 "bc4e8db0bc4570390f5e92327ecb33caabea98696b3708f270aa06775935716b"
  head "https://github.com/Difegue/LANraragi.git"

  depends_on "pkg-config" => :build
  depends_on "cpanminus"
  depends_on "libarchive"
  depends_on "libjpeg"
  depends_on "libpng"
  depends_on "node"
  depends_on "openssl"
  depends_on "perl" => "5.20.2"
  depends_on "redis"

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    ENV.prepend_path "PERL5LIB", libexec/"lib"

    system "npm", "install", *Language::Node.local_npm_install_args
    system "perl", "./tools/install.pl", "install-full"
    prefix.install "lib"
    prefix.install "script"
    prefix.install "lrr.conf"
    prefix.install "package.json"
    prefix.install "public"
    prefix.install "README.md"
    prefix.install "templates"
    prefix.install "log"
    prefix.install "tools/homebrew-start/redis.conf"
    bin.install "tools/homebrew-start/lanraragi"
  end
end
