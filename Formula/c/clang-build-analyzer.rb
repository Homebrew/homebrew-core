class ClangBuildAnalyzer < Formula
  desc "Tool to analyze compilation time"
  homepage "https://github.com/aras-p/ClangBuildAnalyzer"
  url "https://github.com/aras-p/ClangBuildAnalyzer/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "c63aaf085bcb8086f97397c37f4b5af500b5874633ca2b2c7e66eb98d654ff76"
  license all_of: ["Unlicense", "Zlib", "MIT", "BSL-1.0", "BSD-3-Clause", "Apache-2.0",
                   "BSD-2-Clause", "Apache-2.0" => { with: "LLVM-exception" }]
  head "https://github.com/aras-p/ClangBuildAnalyzer.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "39e181034cc9b1b27e4196a184addba7fe5e84eb31f0e4c4c6492941356346d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8335ed1e120e766c0c1fc493574a13e0a2af945314fb1b86151b1467d1e4a9ca"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7e8e965cd93f4c6784554fb22ea5f38481c206e964612a0944994835adf66196"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b193fae6fcbfd27288032cb42fc65680205dd1459960d1b930bc585919b0a30e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b5434cf1e70850de6ea97de9bc8bcd14eee35796515808242351e1434b95ae6a"
    sha256 cellar: :any_skip_relocation, sonoma:         "33ac6bfac9fbd196ae9a156581e93366832061ccfd52e2c4471558040b280315"
    sha256 cellar: :any_skip_relocation, ventura:        "efcf833391026cade52ace3bc25a34ae807f078aab68c6f5224ace21fe217b3a"
    sha256 cellar: :any_skip_relocation, monterey:       "0ec3710ce4eb2592808e14283294e057413d6375bae5c70344d5d4987f8b10e0"
    sha256 cellar: :any_skip_relocation, big_sur:        "fc16233d0ba32390ef2057f28c3a7d8f663d64f6f10c2ea66c854e27e6389aa8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12d49dd51ba5c2e8d559d5698ce8ca0fc4f13c9ac64f34c99ac57e037e5dc8fc"
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
