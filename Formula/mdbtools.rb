class Mdbtools < Formula
  desc "Tools to facilitate the use of Microsoft Access databases"
  homepage "https://github.com/brianb/mdbtools/"
  url "https://github.com/brianb/mdbtools/archive/0.7.1.tar.gz"
  sha256 "dcf310dc7b07e7ad2f9f6be16047dc81312cfe1ab1bd94d0fa739c8059af0b16"
  revision 1

  bottle do
    cellar :any
    sha256 "e161be6807c2bda9ad9fd70549e3f94b5f953d5c8ef70a1261f6b09ec6ac9e45" => :sierra
    sha256 "2cb35611ad74402c45bb691d5c37943552b7494ebcdfdc31fd3a68a16c2a2b0c" => :el_capitan
    sha256 "7e43a2716347e3f89782134b53ca5bf240fd1ebd91025393737fc17b9e09aa21" => :yosemite
  end

  option "with-man-pages", "Build manual pages"

  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "txt2man" => :build if build.with? "man-pages"
  depends_on "glib"
  depends_on "readline"

  def install
    ENV.deparallelize

    args = ["--prefix=#{prefix}"]
    args << "--disable-man" if build.without? "man-pages"

    if MacOS.version == :snow_leopard
      mkdir "build-aux"
      touch "build-aux/config.rpath"
    end

    system "autoreconf", "-i", "-f"
    system "./configure", *args
    system "make", "install"
  end
end
