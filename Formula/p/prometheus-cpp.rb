class PrometheusCpp < Formula
  desc "Prometheus Client Library for Modern C++"
  homepage "https://github.com/jupp0r/prometheus-cpp"
  url "https://github.com/jupp0r/prometheus-cpp.git",
      tag:      "v1.2.4",
      revision: "ad99e21f4706193670c42b36c9824dc997f4c475"
  license "MIT"
  head "https://github.com/jupp0r/prometheus-cpp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "c2571779537dc5ab9240204f8abc79daa0e004d1e0706bfad50f8572a1b429a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d668756a9f2cce815bb21d4cc57f6650033e16c9f6075e182a83c9be2b8faf87"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ed12e2d6e073c2cf5d8d944f38ba7b825c464db9cea604c786442ee87c68f2f7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec2d1f82b26e4646b33f50555000040a2b60092ceb3e12b0141134644aa7e973"
    sha256 cellar: :any_skip_relocation, sonoma:         "60fc60c44cc6a6ebcb497fbd1bf1e5b55d4edabfc8be33f7983409ffd8beeee0"
    sha256 cellar: :any_skip_relocation, ventura:        "9ed018a937326f595e2d8b0901471e804bf1656249410f6d41d6e3d3a4ac9eb2"
    sha256 cellar: :any_skip_relocation, monterey:       "d0a4bc233403aa98f488f60cb7e6d1d8f3d03348b88b7ded8e18c2fb4e59ff35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00a319b9c7930f5555e55783aa88a149b738d34565069e19b6141c20300e59ed"
  end

  depends_on "cmake" => :build
  uses_from_macos "curl"
  uses_from_macos "zlib"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <prometheus/registry.h>
      int main() {
        prometheus::Registry reg;
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++14", "test.cpp", "-I#{include}", "-L#{lib}", "-lprometheus-cpp-core", "-o", "test"
    system "./test"
  end
end
