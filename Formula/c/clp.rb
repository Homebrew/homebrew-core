class Clp < Formula
  desc "Linear programming solver"
  homepage "https://github.com/coin-or/Clp"
  url "https://github.com/coin-or/Clp/archive/refs/tags/releases/1.17.10.tar.gz"
  sha256 "0d79ece896cdaa4a3855c37f1c28e6c26285f74d45f635046ca0b6d68a509885"
  license "EPL-2.0"

  livecheck do
    url :stable
    regex(%r{^(?:releases/)?v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "f875557c40925c2c5b0776bf226aa6c8a9f49594d16d7535c50c7e1984176144"
    sha256 cellar: :any,                 arm64_sequoia:  "5ddbd8974678d1107ae7c8a2fe698263e0cf12e8c5e2b03d13ce58a11d80c62e"
    sha256 cellar: :any,                 arm64_sonoma:   "523d06de70cf0898e482d4e7145cb74cc40ff7bae931db5aeb252c2b047842d4"
    sha256 cellar: :any,                 arm64_ventura:  "3f3334798b217d9de284e6cce8072a63b8df974dc55f43f506a388bdfc98ee3d"
    sha256 cellar: :any,                 arm64_monterey: "de2b76d01b18509c8db1af0b8bf777eb6ab5083feb3517f0be57b7e158495484"
    sha256 cellar: :any,                 sonoma:         "73f92e5e65141f07f3b878b8fa5a212f70dadc4b9d19f803cf45e3a00edddd0c"
    sha256 cellar: :any,                 ventura:        "d6f0d8287373e84ba11e9db75999a442879a6802f24520616c4bf6b204d63ffc"
    sha256 cellar: :any,                 monterey:       "a1bca012e38bffd8377562a7fcf4ec3739dc57cd08fd7918f16e0a56a202eeca"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "2d629ba3d4e212476ae6e6c4172ccc97bf88acac38f1982de82aa07560da98a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3de80fe042a6689294193c7efbb4d794ee37c3e1194dcdb311b740acb6ffba09"
  end

  depends_on "pkgconf" => [:build, :test]
  depends_on "coinutils"
  depends_on "openblas"
  depends_on "osi"

  resource "coin-or-tools-data-sample-p0033-mps" do
    url "https://raw.githubusercontent.com/coin-or-tools/Data-Sample/releases/1.2.12/p0033.mps"
    sha256 "8ccff819023237c79ef32e238a5da9348725ce9a4425d48888baf3a0b3b42628"
  end

  def install
    # Work around https://github.com/coin-or/Clp/issues/109:
    # Error 1: "mkdir: #{include}/clp/coin: File exists."
    mkdir include/"clp/coin"

    args = [
      "--datadir=#{pkgshare}",
      "--disable-silent-rules",
      "--includedir=#{include}/clp",
      "--with-blas-incdir=#{Formula["openblas"].opt_include}",
      "--with-blas-lib=-L#{Formula["openblas"].opt_lib} -lopenblas",
      "--with-lapack-incdir=#{Formula["openblas"].opt_include}",
      "--with-lapack-lib=-L#{Formula["openblas"].opt_lib} -lopenblas",
    ]
    system "./configure", *args, *std_configure_args
    system "make", "install"
  end

  test do
    resource("coin-or-tools-data-sample-p0033-mps").stage testpath
    system bin/"clp", "-import", testpath/"p0033.mps", "-primals"
    (testpath/"test.cpp").write <<~CPP
      #include <ClpSimplex.hpp>
      int main() {
        ClpSimplex model;
        int status = model.readMps("#{testpath}/p0033.mps", true);
        if (status != 0) { return status; }
        status = model.primal();
        return status;
      }
    CPP
    pkg_config_flags = shell_output("pkg-config --cflags --libs clp").chomp.split
    system ENV.cxx, "test.cpp", *pkg_config_flags
    system "./a.out"
  end
end
