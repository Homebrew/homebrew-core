class Minizinc < Formula
  desc "Medium-level constraint modeling language"
  homepage "https://www.minizinc.org/"
  url "https://github.com/MiniZinc/libminizinc/archive/refs/tags/2.9.4.tar.gz"
  sha256 "6927a58fb1768f2f5f393cc642654a14c0e2c215dd8d6c9f226577cacc057d92"
  license "MPL-2.0"
  head "https://github.com/MiniZinc/libminizinc.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "d2495a3d41a8c514209e6d64922091443075dbf228a20ea0ee4a4d0fc2faa62a"
    sha256 arm64_sequoia: "8ef0ae597cdefb9565ef9bb4e0b52d9a238fccd09bb3652d0e35cb9bf56cd253"
    sha256 arm64_sonoma:  "8a9d3758932cf80762b85f562f8e433d171718102d0f55c5cb05821e21c89af1"
    sha256 sonoma:        "8d3cd83922ae6f7fe0e769f8e55f23ee0467b93c69da8ad14808381c4e0e7f51"
    sha256 arm64_linux:   "70d1ace81bf773bc8a470c5acfa5f70b23370201d47939e4ef813de42a051c51"
    sha256 x86_64_linux:  "a0a1f4098b52483439c4e3e3ca0cd5b10a548f2b373684f062f7bbf48548096f"
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
