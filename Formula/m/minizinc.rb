class Minizinc < Formula
  desc "Medium-level constraint modeling language"
  homepage "https://www.minizinc.org/"
  license "MPL-2.0"
  revision 1
  head "https://github.com/MiniZinc/libminizinc.git", branch: "develop"

  stable do
    url "https://github.com/MiniZinc/libminizinc/archive/refs/tags/2.10.1.tar.gz"
    sha256 "089ea94698cea94ed8396be77559b82d828437a808f5e37d10bccc9f1d39dd33"

    # Prerequisite for the C++14 backport.
    patch do
      url "https://github.com/MiniZinc/libminizinc/commit/7eeecc2edc019f554de80be62da9ba58c31b3eca.patch?full_index=1"
      sha256 "51966edea574e3c985ee5b58c45e3d69199e6dafa8257a2865d8fe5c63d16d7e"
      type :backport
    end

    # Build with C++14 for compatibility with Gecode 6.5.
    patch do
      url "https://github.com/MiniZinc/libminizinc/commit/ced572f764dd17973b5b3bcc14af647e8751a42d.patch?full_index=1"
      sha256 "27d20337469464471773b63a468b58f9e7c4e7c6af204e3daca8d8bd2ad58938"
      type :backport
    end
  end

  bottle do
    sha256 arm64_golden_gate: "1a3cfd0f6a669898370629ad5678e49f544dcebfdac47d05e761d5f07087f7dd"
    sha256 arm64_tahoe:       "31aeac75fa462a55dca0d810bdd8106338b63dfdf939db564f94554fc1691e0f"
    sha256 arm64_sequoia:     "44f77ee6be4dc34ac587062704073a866aa0cc8ad052d3308dc50d9cb1a13a39"
    sha256 arm64_linux:       "5f6bc4ac481fc5fe2f7103716ffb3dcb49cea9d4ef0c4b0c627217f903e8adfa"
    sha256 x86_64_linux:      "85ee3fefa5887e1cd1bec8aa983e94a27a5c3338a64bf22e78f42bbb1979fce2"
  end

  depends_on "cmake" => :build

  depends_on "cbc"
  depends_on "cgl"
  depends_on "clp"
  depends_on "coinutils"
  depends_on "gecode"
  depends_on "osi"

  deny_network_access!

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
