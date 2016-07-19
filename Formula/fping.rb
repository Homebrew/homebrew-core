class Fping < Formula
  desc "Scriptable ping program for checking if multiple hosts are up"
  homepage "http://fping.org/"
  url "http://fping.org/dist/fping-3.13.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/f/fping/fping_3.13.orig.tar.gz"
  sha256 "4bb28efd1cb3d1240ae551dadc20daa852b1ba71bafe32e49ca629c1848e5720"

  bottle do
    cellar :any_skip_relocation
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
