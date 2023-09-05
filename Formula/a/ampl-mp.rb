class AmplMp < Formula
  desc "Open-source library for mathematical programming"
  homepage "https://www.ampl.com/"
  url "https://github.com/ampl/mp/archive/3.1.0.tar.gz"
  sha256 "587c1a88f4c8f57bef95b58a8586956145417c8039f59b1758365ccc5a309ae9"
  license "MIT"
  revision 3

  livecheck do
    url "https://github.com/ampl/mp.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0a6ec6b35631a0156e62ed56554b734b7d621ce0933784cf154d09c9d6419a30"
    sha256 cellar: :any,                 arm64_monterey: "27fdafce7e558441048fe2107a783304a5ebb275fdb1c435f0f30a6135d3bbf5"
    sha256 cellar: :any,                 arm64_big_sur:  "5a666c8f40e7d66e6c065e21abada4c2fbfc5917fed422beb6c14b357e0e41b2"
    sha256 cellar: :any,                 ventura:        "7f1af712490a2a051c72196a15a17061184b1f0c0c2f29852455fb68c5895a6c"
    sha256 cellar: :any,                 monterey:       "c2323285b97b8a697e564fc444fd3dd4424cb3d6a1ea6e8e336735eee5e3ac5f"
    sha256 cellar: :any,                 big_sur:        "512e10d2061408b42b14b9834bdb4f4ad85f859c578ebab99efda98d3f6f4957"
    sha256 cellar: :any,                 catalina:       "c111c501330b3ff8e3bde1a7e679f162bea1038df07de96810ea5cbe34775740"
    sha256 cellar: :any,                 mojave:         "bf329d7a40c3a21cb745d9d86bc0cf4add18397aedd6b36eb8e27feab822f1e3"
    sha256 cellar: :any,                 high_sierra:    "835aea5e86e3780681cb38ebe0f0dcd522ed21f80ed4711ad10e66b6c0814d03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4efb0ad66f2cd0930a0f5f50edf249ac4c8f436f34b5b8cf95b90199d1d5d3e9"
  end

  depends_on "cmake" => :build

  resource "miniampl" do
    url "https://github.com/dpo/miniampl/archive/v1.0.tar.gz"
    sha256 "b836dbf1208426f4bd93d6d79d632c6f5619054279ac33453825e036a915c675"
  end

  # Removes Google Benchmark - as already done so upstream
  # All it did was conflict with the google-benchmark formula
  patch do
    url "https://github.com/ampl/mp/commit/96e332bb8cb7ba925e3ac947d6df515496027eed.patch?full_index=1"
    sha256 "1a4ef4cd1f4e8b959c20518f8f00994ef577e74e05824b2d1b241b1c3c1f84eb"
  end

  def install
    system "cmake", ".", *std_cmake_args, "-DBUILD_SHARED_LIBS=True"
    system "make", "all"
    if OS.mac?
      MachO::Tools.change_install_name("bin/libasl.dylib", "@rpath/libmp.3.dylib",
                                       "#{opt_lib}/libmp.dylib")
    end
    system "make", "install"

    # Shared modules are installed in bin
    mkdir_p libexec/"bin"
    mv Dir[bin/"*.dll"], libexec/"bin"

    # Install missing header files, remove in > 3.1.0
    # https://github.com/ampl/mp/issues/110
    %w[errchk.h jac2dim.h obj_adj.h].each { |h| cp "src/asl/solvers/#{h}", include/"asl" }

    resource("miniampl").stage do
      (pkgshare/"example").install "src/miniampl.c", Dir["examples/wb.*"]
    end
  end

  test do
    system ENV.cc, pkgshare/"example/miniampl.c", "-std=c99", "-I#{include}/asl", "-L#{lib}", "-lasl", "-lmp"
    cp Dir[pkgshare/"example/wb.*"], testpath
    output = shell_output("./a.out wb showname=1 showgrad=1")
    assert_match "Objective name: objective", output
  end
end
