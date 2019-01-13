class Mdbtools < Formula
  desc "Tools to facilitate the use of Microsoft Access databases"
  homepage "https://github.com/brianb/mdbtools/"
  url "https://github.com/brianb/mdbtools/archive/0.7.1.tar.gz"
  sha256 "dcf310dc7b07e7ad2f9f6be16047dc81312cfe1ab1bd94d0fa739c8059af0b16"
  revision 2

  bottle do
    cellar :any
    sha256 "8949564dd437320e1b5bc81a54c21f03ac8847cd4fb466c242bb94d28be8569a" => :mojave
    sha256 "e25f5c22dec759fb6e4d1f9ec448f2bfe162d619a11d16ffcd132f7a20f813de" => :high_sierra
    sha256 "61056fac90d6b15e9298ccd12afa4f4fbb8906abe7dfd32df84342c01da787be" => :sierra
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
