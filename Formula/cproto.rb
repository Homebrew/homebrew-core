class Cproto < Formula
  desc "Generate function prototypes for functions in input files"
  homepage "https://invisible-island.net/cproto/"
  url "https://invisible-mirror.net/archives/cproto/cproto-4.7p.tgz"
  mirror "https://deb.debian.org/debian/pool/main/c/cproto/cproto_4.7p.orig.tar.gz"
  sha256 "d202334ff47fb40a1f57425135ebeefcbb272103f8fd7572e8ea21ee093aa16e"

  bottle do
    cellar :any_skip_relocation
    sha256 "2791bdef02007dabef1d3129853b566ebe82012479336d52d892be8add1fbe56" => :catalina
    sha256 "b53d9e4fe9ef19daed4017bc47fbd1ec2803859d78ecca96bd0e53a0ea18e3e1" => :mojave
    sha256 "fd7ccdeb13066090ff755fa70f88b7453d65eab0e14d30187429b08808aa66fe" => :high_sierra
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"

    system "make", "install"
  end

  test do
    (testpath/"woot.c").write("int woot() {\n}")
    assert_match(/int woot.void.;/, shell_output("#{bin}/cproto woot.c"))
  end
end
