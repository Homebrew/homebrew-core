class Cloog < Formula
  desc "Generate code for scanning Z-polyhedra"
  homepage "https://www.bastoul.net/cloog/"
  url "https://www.bastoul.net/cloog/pages/download/count.php3?url=./cloog-0.18.4.tar.gz"
  sha256 "325adf3710ce2229b7eeb9e84d3b539556d093ae860027185e7af8a8b00a750e"
  revision 3

  bottle do
    cellar :any
    sha256 "f26e41c339aaf9d6207d9843f9e9a0c93d623d6cfb4e1b9d1f536afee85e25ea" => :mojave
    sha256 "32b9d6ae3b69a1ac153d83997999add0a5836214c21d41fe18a0ef2dd44b3123" => :high_sierra
    sha256 "f517f774f48f11a1fdcf7d0023bdeacbd919cb22085a539fba539fac80025826" => :sierra
    sha256 "2e4ac62185b9291272f07381c19bba476eac505a40ff974aa8017b9ec4359b13" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "gmp"

  resource "isl" do
    url "http://isl.gforge.inria.fr/isl-0.18.tar.xz"
    mirror "https://mirrors.ocf.berkeley.edu/debian/pool/main/i/isl/isl_0.18.orig.tar.xz"
    sha256 "0f35051cc030b87c673ac1f187de40e386a1482a0cfdf2c552dd6031b307ddc4"
  end

  def install
    resource("isl").stage do
      system "./configure", "--disable-dependency-tracking",
                            "--disable-silent-rules",
                            "--prefix=#{libexec}",
                            "--with-gmp=system",
                            "--with-gmp-prefix=#{Formula["gmp"].opt_prefix}"
      system "make", "install"
    end

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-gmp=system",
                          "--with-gmp-prefix=#{Formula["gmp"].opt_prefix}",
                          "--with-isl=system",
                          "--with-isl-prefix=#{libexec}"
    system "make", "install"
  end

  test do
    cloog_source = <<~EOS
      c

      0 2
      0

      1

      1
      0 2
      0 0 0
      0

      0
    EOS

    output = pipe_output("#{bin}/cloog /dev/stdin", cloog_source)
    assert_match %r{Generated from /dev/stdin by CLooG}, output
  end
end
