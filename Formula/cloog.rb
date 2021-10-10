class Cloog < Formula
  desc "Generate code for scanning Z-polyhedra"
  homepage "http://www.bastoul.net/cloog/"
  url "http://www.bastoul.net/cloog/pages/download/count.php3?url=./cloog-0.18.4.tar.gz"
  sha256 "325adf3710ce2229b7eeb9e84d3b539556d093ae860027185e7af8a8b00a750e"
  revision 3

  livecheck do
    url "http://www.bastoul.net/cloog/download.php"
    regex(/href=.*?cloog[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_big_sur: "fd2c1ec09cd145694be31a83b63ce8d12a78475a9329337d17c54acf32a5bdab"
    sha256 cellar: :any,                 big_sur:       "f7c327b7541e01820a0b70ac9877dae9263609de74480aad14568a505ee7af83"
    sha256 cellar: :any,                 catalina:      "7899742ca2ecd424f8354679f710d86329abf9935017dd0952950b485b0d9967"
    sha256 cellar: :any,                 mojave:        "604d9bd3eaab93d10f50d3dacf0c9c49b2b986b3a6379a95586fe4c4cbf26622"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3fc2e061afb37bcc0d067989d11dba0997cd840d1ee627ec0be561c6bec4924c"
  end

  depends_on "pkg-config" => :build
  depends_on "gmp"

  resource "isl" do
    url "https://libisl.sourceforge.io/isl-0.18.tar.xz"
    mirror "https://deb.debian.org/debian/pool/main/i/isl/isl_0.18.orig.tar.xz"
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
    (testpath/"test.cloog").write <<~EOS
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

    assert_match %r{Generated from #{testpath}/test.cloog by CLooG},
                 shell_output("#{bin}/cloog #{testpath}/test.cloog")
  end
end
