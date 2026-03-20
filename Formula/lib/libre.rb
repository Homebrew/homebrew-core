class Libre < Formula
  desc "Toolkit library for asynchronous network I/O with protocol stacks"
  homepage "https://github.com/baresip/re"
  url "https://github.com/baresip/re/archive/refs/tags/v4.6.0.tar.gz"
  sha256 "811f19ed3df60f75070c07fc0eb5f767574e5b6dc2f12a679df04df381a43d88"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7f6ffa21771c5db9fd4c727a14086581e7774b3fee41374c5a2a3a73d449cbb2"
    sha256 cellar: :any,                 arm64_sequoia: "8687b9526581bbfaf1ffb4ecc5267bfa8631223eb8ebdc832136005247ef678f"
    sha256 cellar: :any,                 arm64_sonoma:  "f1de37b2d090a86287bd28c7f9dd8b6d23715226344885689422e4743cb58b9b"
    sha256 cellar: :any,                 sonoma:        "dd6626b910acaed136424c8b96934c433ac0c94b0d4b2bac23e3f46d4fd98d9e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "73ea09f512b0b3c0dc4f3a1d8c1caee5cc4793aa8495ad32c6b036266356c330"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c225de4a857fcdcbc4fe7081afe56212154156e52134e955bd0fd3ee68b3345d"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cmake", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdint.h>
      #include <re/re.h>
      int main() {
        return libre_init();
      }
    C
    system ENV.cc, "-I#{include}", "-I#{include}/re", "test.c", "-L#{lib}", "-lre"
  end
end
