class Codequery < Formula
  desc "Code-understanding, code-browsing or code-search tool"
  homepage "https://ruben2020.github.io/codequery/"
  url "https://github.com/ruben2020/codequery/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "6e893332f623dcb82256afcd4347084e4135e2fdb5f765865773ad6f6e64f3fe"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "699c385165820cc6959a2f2d03a1a9c813e83ed9e8004b5dc81cefff1b3ff49c"
    sha256 cellar: :any, arm64_sequoia: "671cfc9d735b78eb01a803a48ef43f300dd3196e2d1dfaa0cee793ec270b9baa"
    sha256 cellar: :any, arm64_sonoma:  "f5bc20f078e1ddec21f9103503edf8fc87bc8203f960a6beb017a27e63fe916d"
    sha256 cellar: :any, sonoma:        "d2a15d26e0624b2c24a1c76f1dda86ad8e17413e6cd696a3ec97bb892bf3f032"
    sha256 cellar: :any, arm64_linux:   "35c4bf6ee5bb8b19098a394d7c02e0d7941467d7c042f2014a8b6b3bc9d00744"
    sha256 cellar: :any, x86_64_linux:  "cdb198b5255ce27f58b0fe87546cd648a0c48cdde1ecbf677ff4118b3d7d9131"
  end

  depends_on "cmake" => :build
  depends_on "qttools" => :build
  depends_on "qt5compat"
  depends_on "qtbase"
  depends_on "sqlite"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "test"
  end

  test do
    # Copy test files as `cqmakedb` gets confused if we just symlink them.
    cp (pkgshare/"test").children, testpath

    system bin/"cqmakedb", "-s", "./codequery.db",
                           "-c", "./cscope.out",
                           "-t", "./tags",
                           "-p"
    output = shell_output("#{bin}/cqsearch -s ./codequery.db -t info_platform")
    assert_match "info_platform", output
  end
end
