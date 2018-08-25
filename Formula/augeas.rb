class Augeas < Formula
  desc "Configuration editing tool and API"
  homepage "http://augeas.net"
  url "http://download.augeas.net/augeas-1.11.0.tar.gz"
  sha256 "393ce8f4055af89cd4c20bf903eacbbd909cf427891f41b56dc2ba66243ea0b0"

  bottle do
    sha256 "bfaace680febb27691ea0c8242d9d8a3639c4fe525b68d3b2b5973c49f4b2fed" => :mojave
    sha256 "22f139b71f14cc0c7c1eddef04c20ab2ad66f7e91c90ebd21198b604b6630844" => :high_sierra
    sha256 "60d58e8099a4f02a4f4d2eed7eb9114cee19e965c29dfd4102de036a896d4986" => :sierra
    sha256 "5c0c8b3f140464288045010acf62f230bced7bfa2282d048bd2fcade90673e1b" => :el_capitan
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
