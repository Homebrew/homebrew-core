class Minizinc < Formula
  desc "Medium-level constraint modeling language"
  homepage "https://www.minizinc.org/"
  url "https://github.com/MiniZinc/libminizinc/archive/refs/tags/2.11.0.tar.gz"
  sha256 "9c88aa270864d78c4f39437533796f5bf60bf71bec78f02685742b2c44aeba26"
  license "MPL-2.0"
  head "https://github.com/MiniZinc/libminizinc.git", branch: "develop"

  bottle do
    sha256 arm64_golden_gate: "6f705d0126522da0ec58721180ed0f68a24b942b448eeae957dd36b5111e92bb"
    sha256 arm64_tahoe:       "6f75738dc5376b2e3f33010d86a70a1f3c84cb99383f1781126305a582d98a9b"
    sha256 arm64_sequoia:     "67f0139801803b015444ee08a3072dfb7be2e0a3ae3c46d46b79a5ca21453e54"
    sha256 arm64_linux:       "350d2829790c1151f156b1aaeb42eeb2aea60401bf3273675772a90450d8ac93"
    sha256 x86_64_linux:      "dba1ed869600dd8f0ae4b70e456e635f673c2f0faea2752f9400142b0be96b9e"
  end

  depends_on "cmake" => :build

  depends_on "cbc"
  depends_on "cgl"
  depends_on "clp"
  depends_on "coinutils"
  depends_on "gecode"
  depends_on "osi"

  resource "tree-sitter" do
    url "https://github.com/tree-sitter/tree-sitter/archive/refs/tags/v0.26.12.tar.gz"
    sha256 "428e2b182fe38eddc100d8bd851e47c96921a69281b66abafc25ba4b0aaeeeab"

    livecheck do
      url "https://raw.githubusercontent.com/MiniZinc/libminizinc/#{LATEST_VERSION}/cmake/targets/libminizinc_parser.cmake"
      regex(%r{tree-sitter/archive/refs/tags/v?(\d+(?:\.\d+)+)\.t}i)
    end
  end

  resource "tree-feller" do
    url "https://github.com/Dekker1/tree-feller/archive/refs/tags/v0.1.1.tar.gz"
    sha256 "4a6b463da95ec6a9a1014732df6e77dabdb5e20c95cd9005107d1d4596e92cf9"

    livecheck do
      url "https://raw.githubusercontent.com/MiniZinc/libminizinc/#{LATEST_VERSION}/cmake/targets/libminizinc_parser.cmake"
      regex(%r{tree-feller/archive/refs/tags/v?(\d+(?:\.\d+)+)\.t}i)
    end
  end

  deny_network_access!

  def install
    (buildpath/"tree-sitter").install resource("tree-sitter")
    (buildpath/"tree-feller").install resource("tree-feller")

    # Avoid overlinking to `qtbase` via Gecode's exported CMake targets
    ENV.append "LDFLAGS", "-Wl,-dead_strip_dylibs" if OS.mac?

    args = %W[
      -DMZN_USE_MIMALLOC=OFF
      -DFETCHCONTENT_FULLY_DISCONNECTED=ON
      -DFETCHCONTENT_SOURCE_DIR_TREE-SITTER=#{buildpath}/tree-sitter
      -DFETCHCONTENT_SOURCE_DIR_TREE_FELLER=#{buildpath}/tree-feller
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
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
