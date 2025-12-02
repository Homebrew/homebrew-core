class Codequery < Formula
  desc "Code-understanding, code-browsing or code-search tool"
  homepage "https://ruben2020.github.io/codequery/"
  url "https://github.com/ruben2020/codequery/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "40781a7499adddddcb9b7ab2d1d840453aed08f91f5ebc7c339c2f13f63a9403"
  license "MPL-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "ec9b55288deede50bb5a39e76846aa3a0c7179be2a1ceb1f682b6de5291abdc3"
    sha256 cellar: :any,                 arm64_sequoia: "683318cd26452dda4e8b6f103fcf5c0bacb6d886da49b3492e87dc8bab7ef35e"
    sha256 cellar: :any,                 arm64_sonoma:  "1078139feee794760c6e6c42f33c49d308d4f308098e9913636d8054fe1da150"
    sha256 cellar: :any,                 sonoma:        "57c3b03bff1a8f7a3311aff6a89c0fb2c530f2f361857af15a9b158ced25476b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b9ef3ff7ab094e9ed1e668874c8dd629a2bceee86fc78f7ad08a90ab72491170"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18b9c0955396a9cd0b50d7b05d4e4b7edc97f8a7a32e693c64f5cfe7f16bbd1b"
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
