class Charls < Formula
  desc "C++ JPEG-LS library implementation"
  homepage "https://github.com/team-charls/charls"
  url "https://github.com/team-charls/charls/archive/refs/tags/2.4.3.tar.gz"
  sha256 "bbf67d51446a98eb8fc98c9c6de49a2605c709d3a14ba39f09a09f8e57527099"
  license "BSD-3-Clause"
  head "https://github.com/team-charls/charls.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d026f97becba3a0bbfaf933fbf767af9da3e1972e1cc9c6b683e4eac2258cdfa"
    sha256 cellar: :any,                 arm64_sequoia: "2c94de1ca73686929663fe7acc812c2cba31bdfcb3495a9cbe4103fc7ac0b95c"
    sha256 cellar: :any,                 arm64_sonoma:  "4c1509a741bb03131dfa27768cd9c5ff9a8a164c53d187e884c0f7adae71bfd7"
    sha256 cellar: :any,                 sonoma:        "5a33c400850f38587bf460f1ad51c36c495123ed0c0439c44bc82b887f9a5466"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "99f69ca4e19039a2dd83c70ecd79fdcf1e1205ccbc76c1e523a5a64a1bac47a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e9a6b109a28f9821c38754a80b8a7e47d0ded3e16f2b207fbe65ed28a58fd2f"
  end

  depends_on "cmake" => :build

  def install
    args = %w[
      -DCHARLS_BUILD_TESTS=OFF
      -DCHARLS_BUILD_FUZZ_TEST=OFF
      -DCHARLS_BUILD_SAMPLES=OFF
      -DBUILD_SHARED_LIBS=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <charls/charls.h>
      #include <iostream>

      int main() {
        charls::jpegls_encoder encoder;
        std::cout << "ok" << std::endl;
        return 0;
      }
    CPP

    system ENV.cxx, "test.cpp", "-std=c++14", "-I#{include}", "-L#{lib}", "-lcharls", "-o", "test"
    assert_equal "ok", shell_output(testpath/"test").chomp
  end
end
