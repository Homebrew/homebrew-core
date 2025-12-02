class ClangBuildAnalyzer < Formula
  desc "Tool to analyze compilation time"
  homepage "https://github.com/aras-p/ClangBuildAnalyzer"
  url "https://github.com/aras-p/ClangBuildAnalyzer/archive/refs/tags/v1.6.0.tar.gz"
  sha256 "868a8d34ecb9b65da4e5874342062a12c081ce4385c7ddd6ce7d557a0c5c292d"
  license all_of: ["Unlicense", "Zlib", "MIT", "BSL-1.0", "BSD-3-Clause", "Apache-2.0",
                   "BSD-2-Clause", "Apache-2.0" => { with: "LLVM-exception" }]
  head "https://github.com/aras-p/ClangBuildAnalyzer.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "14419000811d5bef08eaa62f796264dc5268bb9a95a7b907c6e38936f06ab1ab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e93f14923fdb699565dced9177cb214af4e3da61fca3d4de41461eefa32c0b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85f62673e238f3a630999432c37ba819a013b594b81df913fe28a90a66801e17"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1fd243d037fbb89eaf7fdb5283d6154c7b8f0140b4507c5384c8c2b318d3c710"
    sha256 cellar: :any_skip_relocation, sonoma:        "d4af487341370185ae6ebb035629646ffcfc5590961e8250eba3b93e82618ef6"
    sha256 cellar: :any_skip_relocation, ventura:       "408f71d00639f0865e7d41c01b54406c490e5ac27bbece37352ae90b1d443512"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "72c0d64de559f8b07488a1d052faf7790fa89194449e5a349a4acb6fa120c919"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dcdefa484105d4b981757deb4ce19d98c2c5fb8eda65ba1ccbb332958188e064"
  end

  depends_on "cmake" => :build
  uses_from_macos "llvm"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cxx").write <<~CPP
      int main() {}
    CPP
    ENV.clang
    system ENV.cxx, "-c", "-ftime-trace", testpath/"test.cxx"
    system bin/"ClangBuildAnalyzer", "--all", testpath, "test.db"
    system bin/"ClangBuildAnalyzer", "--analyze", "test.db"
  end
end
