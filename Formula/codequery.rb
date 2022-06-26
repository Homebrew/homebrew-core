class Codequery < Formula
  desc "Code-understanding, code-browsing or code-search tool"
  homepage "https://github.com/ruben2020/codequery"
  url "https://github.com/ruben2020/codequery/archive/refs/tags/v0.25.0.tar.gz"
  sha256 "200bed981e89fe02770a7a76516714d6d6345021d6ae89e68341b6af39728407"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "24a4898739d208f8dfda2bf7f02eed21dfe82bc4c8a938cef94c314c5658b97f"
    sha256 cellar: :any,                 arm64_big_sur:  "3f80c4407314da08b4a576c3434c7e4ad29479752d6b45bf9572d3bd4010657d"
    sha256 cellar: :any,                 monterey:       "0c9479b9d18664bedef6d9d9ac4582b536616b3fa87c64a6e0c75826a94fe50c"
    sha256 cellar: :any,                 big_sur:        "1b660bfc8bc5dbe29ee1572d4f23ff97e8d0ce0f7010bdb9ee709ac87a323bde"
    sha256 cellar: :any,                 catalina:       "78858d75d1980b20a592a04321fe552a3358155ed9f21b4b1a6ca15f10a9a50a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9838cc9f35121d8391d6ce91b60119d61c412bfe55f48e520014ca5888fe769"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "qt@5"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    args = std_cmake_args

    share.install "test"
    mkdir "build" do
      system "cmake", "..", "-G", "Ninja", *args
      system "ninja"
      system "ninja", "install"
    end
  end

  test do
    # Copy test files as `cqmakedb` gets confused if we just symlink them.
    test_files = (share/"test").children
    cp test_files, testpath

    system "#{bin}/cqmakedb", "-s", "./codequery.db",
                              "-c", "./cscope.out",
                              "-t", "./tags",
                              "-p"
    output = shell_output("#{bin}/cqsearch -s ./codequery.db -t info_platform")
    assert_match "info_platform", output
  end
end
