class Augeas < Formula
  desc "Configuration editing tool and API"
  homepage "http://augeas.net"
  url "http://download.augeas.net/augeas-1.10.0.tar.gz"
  sha256 "2a90f6984c3cca1e64dfcad3af490f38ae86e2f3510ed9e46a391cd947860213"

  bottle do
    sha256 "424a1bbaa89ca69cc7621834110df7eb1868cdc856727fbdbe05718d546cb844" => :high_sierra
    sha256 "5aa2021efaa6b6899010ad94fe886e3b46a8268e1d90eab7429027011dfdf724" => :sierra
    sha256 "28d3591c81fb7ae166d98cc11b64623875cc3fe886f650c9d80d85abf5473c83" => :el_capitan
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
