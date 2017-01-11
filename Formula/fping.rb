class Fping < Formula
  desc "Scriptable ping program for checking if multiple hosts are up"
  homepage "https://fping.org/"
  url "https://fping.org/dist/fping-3.15.tar.gz"
  sha256 "96948f6835bee8925f2556fdf187b59c77c06524e2efc72ddf2bfccb5385521c"

  bottle do
    cellar :any_skip_relocation
    sha256 "539373df806418169185211984af171d17949113c27b0bcc6a612fc1ab897f66" => :sierra
    sha256 "8eb7f8dcb2b887d0376a7587c3176a201a7f626bbfecd8508a80a3360f1cc42d" => :el_capitan
    sha256 "100cb8c769cb5eb8d11648993e5761f46e305a2d8f6b397e387db5ec9f78bb54" => :yosemite
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
