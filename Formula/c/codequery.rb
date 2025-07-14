class Codequery < Formula
  desc "Code-understanding, code-browsing or code-search tool"
  homepage "https://ruben2020.github.io/codequery/"
  url "https://github.com/ruben2020/codequery/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "40781a7499adddddcb9b7ab2d1d840453aed08f91f5ebc7c339c2f13f63a9403"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "441aed26d8bab82bf838568027a57033f7a9fec930840981fd0ef360dcb23c49"
    sha256 cellar: :any,                 arm64_ventura: "7e7fff8e621e9e760732974ccfd9cc12f43d1e869a353af9e52f6440b4e6e73f"
    sha256 cellar: :any,                 sonoma:        "293e7ddd4234c50510567af791016ad5405a8e6a68d20973619d9c24a8b851e1"
    sha256 cellar: :any,                 ventura:       "e8e049d791b8e613c39de8317496941c732de6cab376455f03a673d54c372659"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23df699b0d89b71514dd0014238a1242496b9251274bccc29e38fddd0848d4eb"
  end

  depends_on "cmake" => :build
  depends_on "qt"
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
