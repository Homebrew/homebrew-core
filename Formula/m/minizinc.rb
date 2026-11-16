class Minizinc < Formula
  desc "Medium-level constraint modeling language"
  homepage "https://www.minizinc.org/"
  license "MPL-2.0"
  revision 2
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
