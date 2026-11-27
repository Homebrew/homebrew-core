class Minizinc < Formula
  desc "Medium-level constraint modeling language"
  homepage "https://www.minizinc.org/"
  url "https://github.com/MiniZinc/libminizinc/archive/refs/tags/2.11.0.tar.gz"
  sha256 "9c88aa270864d78c4f39437533796f5bf60bf71bec78f02685742b2c44aeba26"
  license "MPL-2.0"
  head "https://github.com/MiniZinc/libminizinc.git", branch: "develop"

  bottle do
    manifest_sha256 "8d25e6f8af367434c7a5e69febfc8fb63fc48f437285db10c61fda9a0c42fc40"
    sha256 arm64_golden_gate: "c6195fb88ce25ae38f0461d61158d68cff4d7cd0a73a772fc06042f3da065dd8"
    sha256 arm64_tahoe:       "eb6f0eeaef0d6c0f030ba5c0a8d0081b3f8e49c2f3d172cdeeeb23f4b0472c42"
    sha256 arm64_sequoia:     "0d2f402392b5ac228ec61780ab3f77b73646e10706fa29dc04b9aaa4736645c2"
    sha256 arm64_linux:       "4b24ab0690b832e5bac72fc4bb94502e41a955165211c3c9139d4bc608ee2d6d"
    sha256 x86_64_linux:      "93844ff50aff36a1fe9a9405be7a1f783fbd76aec520cbde7fffb6706e552eb1"
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
