class Minizinc < Formula
  desc "Medium-level constraint modeling language"
  homepage "https://www.minizinc.org/"
  url "https://github.com/MiniZinc/libminizinc/archive/refs/tags/2.9.7.tar.gz"
  sha256 "bb04d783dda4bba58de4004afd51d65b1fa4e8d9714c88c129cac312e267152e"
  license "MPL-2.0"
  head "https://github.com/MiniZinc/libminizinc.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "21e719d9abeaee024e6d4a8fb61de4e78c85b561be4c75926b28ea5ebb35d9da"
    sha256 arm64_sequoia: "823e80ca5e2e8b120bf3aef2ced45235e3fe4fcd7e745c04033702f7b34b4965"
    sha256 arm64_sonoma:  "2207824ab90e235bc59c628929439045b174d48d7657c918a6d4ef970e9f04f9"
    sha256 sonoma:        "255661302426073c6bf6fa13306bdaeec31064ace1e5f77e56653143e38444e0"
    sha256 arm64_linux:   "76b1edbce4ea92e5160928cf9a10eb0365bf2282f9445f9b2ffda920dce7e9ad"
    sha256 x86_64_linux:  "b09ec05d0208d12737ae739c438caf6c4f8a870ecfc3d0f54ce8fa76e2b0820f"
  end

  depends_on "cmake" => :build

  depends_on "cbc"
  depends_on "cgl"
  depends_on "clp"
  depends_on "coinutils"
  depends_on "gecode"
  depends_on "osi"

  conflicts_with cask: "minizincide", because: "both install `minizinc` binaries"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"satisfy.mzn").write <<~EOS
      array[1..2] of var bool: x;
      constraint x[1] xor x[2];
      solve satisfy;
    EOS
    assert_match "----------", shell_output("#{bin}/minizinc --solver gecode_presolver satisfy.mzn").strip

    (testpath/"optimise.mzn").write <<~EOS
      array[1..2] of var 1..3: x;
      constraint x[1] < x[2];
      solve maximize sum(x);
    EOS
    assert_match "==========", shell_output("#{bin}/minizinc --solver cbc optimise.mzn").strip
  end
end
