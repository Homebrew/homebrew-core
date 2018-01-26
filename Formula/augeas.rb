class Augeas < Formula
  desc "Configuration editing tool and API"
  homepage "http://augeas.net"
  url "http://download.augeas.net/augeas-1.10.0.tar.gz"
  sha256 "2a90f6984c3cca1e64dfcad3af490f38ae86e2f3510ed9e46a391cd947860213"

  bottle do
    sha256 "14cbc9147bda6bad9c014af9d4693873f47ce1d72fa6c29aa5b85a1702d632b4" => :high_sierra
    sha256 "d7c5e0a0a9c26d56cf6b0f2b28568ee4b25454f33744dacb8aa79fe0c596f8a3" => :sierra
    sha256 "cffbbcf9bb75bd0da58258d9a8996f40c470791fca616eff74485b351fbe0e63" => :el_capitan
  end

  head do
    url "https://github.com/hercules-team/augeas.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "bison" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "readline"

  def install
    args = %W[--disable-debug --disable-dependency-tracking --prefix=#{prefix}]

    if build.head?
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end

    system "make", "install"
  end

  def caveats; <<~EOS
    Lenses have been installed to:
      #{HOMEBREW_PREFIX}/share/augeas/lenses/dist
    EOS
  end

  test do
    system bin/"augtool", "print", etc
  end
end
