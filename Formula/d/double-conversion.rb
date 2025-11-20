class DoubleConversion < Formula
  desc "Binary-decimal and decimal-binary routines for IEEE doubles"
  homepage "https://github.com/google/double-conversion"
  url "https://github.com/google/double-conversion/archive/refs/tags/v3.3.1.tar.gz"
  sha256 "fe54901055c71302dcdc5c3ccbe265a6c191978f3761ce1414d0895d6b0ea90e"
  license "BSD-3-Clause"
  head "https://github.com/google/double-conversion.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1d009a17e50b3df6561a750537ab03932b8739202333d616a8a591626175cabb"
    sha256 cellar: :any,                 arm64_sequoia: "e45a082cb2703fa9054e6399e96aee5104cbeb25ce5e30799af503585e2015d4"
    sha256 cellar: :any,                 arm64_sonoma:  "39944e2a07013b8b8d9dfa6a03eac9123233acdaffd0f79cc3f347defa089c11"
    sha256 cellar: :any,                 arm64_ventura: "5c8a894e848ad27eacaf72d7131731d268292619e8030e51acfcafb4392c3f40"
    sha256 cellar: :any,                 sonoma:        "a6b67d2639ee5159aed9ef0a45f5f2ad4962b4f05d69ef538be5b81fb59bf42b"
    sha256 cellar: :any,                 ventura:       "894479ef1f84789d21a4418decf91ad17e46bcf4622f4a6a7f42be82960f9e24"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "95f103473424f26b95f2100e815664d5370eae8b19a9c1e09678d8bcfa89eb0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5d4229ebfd66a40cef9b63c02533b75762b79d066ffb52da5aca069b4183b849"
  end

  depends_on "cmake" => :build

  # Fix to cmake 4 compatibility
  # PR ref: https://github.com/google/double-conversion/pull/240
  patch do
    url "https://github.com/google/double-conversion/commit/69880f0e68d6ddcb760285709195d63c5fd193c4.patch?full_index=1"
    sha256 "9895afd264e304368d78d83d4bedf85fbd282f79fe99f70cd7384cde2baab329"
  end

  def install
    system "cmake", "-S", ".", "-B", "shared", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "shared"
    system "cmake", "--install", "shared"

    system "cmake", "-S", ".", "-B", "static", "-DBUILD_SHARED_LIBS=OFF", *std_cmake_args
    system "cmake", "--build", "static"
    lib.install "static/libdouble-conversion.a"
  end

  test do
    (testpath/"test.cc").write <<~CPP
      #include <double-conversion/bignum.h>
      #include <stdio.h>
      int main() {
          char buf[20] = {0};
          double_conversion::Bignum bn;
          bn.AssignUInt64(0x1234567890abcdef);
          bn.ToHexString(buf, sizeof buf);
          printf("%s", buf);
          return 0;
      }
    CPP
    system ENV.cc, "test.cc", "-L#{lib}", "-ldouble-conversion", "-o", "test"
    assert_equal "1234567890ABCDEF", `./test`
  end
end
