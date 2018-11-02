class Mdbtools < Formula
  desc "Tools to facilitate the use of Microsoft Access databases"
  homepage "https://github.com/brianb/mdbtools/"
  url "https://github.com/brianb/mdbtools/archive/0.7.1.tar.gz"
  sha256 "dcf310dc7b07e7ad2f9f6be16047dc81312cfe1ab1bd94d0fa739c8059af0b16"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "5d20b6ca1f505f4b7e245c29a602af6982f51873d04b7de3cd20908e23c3c081" => :mojave
    sha256 "6be90f11c93d934c0703285ba77b8f590a1728e85c71c83942b9609e54abc015" => :high_sierra
    sha256 "dffaa22015a33d1b146703dfc97460163b4534572ad0f906bbee66adfc5b3193" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "readline"

  def install
    ENV.deparallelize

    if MacOS.version == :snow_leopard
      mkdir "build-aux"
      touch "build-aux/config.rpath"
    end

    system "autoreconf", "-i", "-f"
    system "./configure", "--prefix=#{prefix}", "--disable-man"
    system "make", "install"
  end
end
