class Fping < Formula
  desc "Scriptable ping program for checking if multiple hosts are up"
  homepage "https://fping.org/"

  stable do
    url "https://fping.org/dist/fping-3.14.tar.gz"
    sha256 "704a574f4a4abeb132e95f89749c1c27b0861ad04262be4c5119e91be25f7a90"

    patch do
      url "https://github.com/schweikert/fping/commit/356e7b3.patch"
      sha256 "b826979d1b9a50bee07092162356de9b667dcac9aa79c780029b57f6da8204f9"
    end
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "81e9995afec8b1517ad82eef18a9cafadbb084a85a1a582b8fe4b44476aaabd3" => :sierra
    sha256 "cf5686f1319e39cb12b440119f703d854caa61ad6f228c900e3f4bd843486e0c" => :el_capitan
    sha256 "30ff58bad8f3fae892bb06f7b1b23780cdf74de27ae902bcc4deea7a25a03d19" => :yosemite
    sha256 "e04ff465c10f41339c09466c58a81f336fe985dfa038cc9c6aeec580fbd53b1d" => :mavericks
  end

  head do
    url "https://github.com/schweikert/fping.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sbindir=#{bin}",
                          "--enable-ipv6"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/fping -A localhost")
    assert_equal "127.0.0.1 is alive", output.chomp
  end
end
