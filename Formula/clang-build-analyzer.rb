class ClangBuildAnalyzer < Formula
  desc "Tool to analyze compilation time"
  homepage "https://github.com/aras-p/ClangBuildAnalyzer"
  url "https://github.com/aras-p/ClangBuildAnalyzer/archive/v1.4.0.tar.gz"
  sha256 "dae8e7838145a72c01c397c3998d9f6801fc4dc819d552010d702cab7dede530"
  license all_of: ["Unlicense", "Zlib", "MIT", "BSL-1.0", "BSD-3-Clause", "Apache-2.0",
                   "BSD-2-Clause", "Apache-2.0" => { with: "LLVM-exception" }]
  head "https://github.com/aras-p/ClangBuildAnalyzer.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "033384eb04d9403e430fa6d21711f3cb60719dceeaf71a84553a60c6bbb3d61f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a933ac5b121555f3dbae54608797f2e2b19bdd4de1de24ee2cafc54f1de6be5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "051d8080f8656cfb3b49a8079bb801a881f86e4418ba8f0ba1d1561458a0cdbd"
    sha256 cellar: :any_skip_relocation, ventura:        "01071d118960d3f1ba3717297648be28d20135681647c8b4741f4acdec873348"
    sha256 cellar: :any_skip_relocation, monterey:       "bbf4f25cc4f6681ab9bdd7d63da4bd8e5ed76d800c6484475623b6abbd0746f6"
    sha256 cellar: :any_skip_relocation, big_sur:        "2d494732c257972bc8738c8983beb7dae65b3ecfb5b4d4b03186b736627008a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "adca3e73a50eb9927e20ae463af18b0df22fe57f85372e76876bd797d7647999"
  end

  depends_on "cmake" => :build
  uses_from_macos "llvm"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cxx").write <<~EOS
      int main() {}
    EOS
    ENV.clang
    system ENV.cxx, "-c", "-ftime-trace", testpath/"test.cxx"
    system bin/"ClangBuildAnalyzer", "--all", testpath, "test.db"
    system bin/"ClangBuildAnalyzer", "--analyze", "test.db"
  end
end
