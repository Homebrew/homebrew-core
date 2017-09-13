class Fping < Formula
  desc "Scriptable ping program for checking if multiple hosts are up"
  homepage "https://fping.org/"
  url "https://fping.org/dist/fping-4.0.tar.gz"
  sha256 "67eb4152b98ad34f99d2eec4e1098a0bb52caf13c0c89cd147349d08190fe8ce"

  bottle do
    cellar :any_skip_relocation
    sha256 "8353b269dbf24bbee719a40b66ee3aa96a1dec70493158f933c3915c98d5321e" => :sierra
    sha256 "4219127df13bbb8e30b71b32b12625299032bf4391bc9d91aef6c587f34b1481" => :el_capitan
    sha256 "049fcd3af217fe04df09a55d3eee85608dabc16d307a5213235431008bd1cadb" => :yosemite
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
                          "--sbindir=#{bin}"
    system "make", "install"
  end

  test do
    assert_equal "::1 is alive", shell_output("#{bin}/fping -A localhost").chomp
  end
end
