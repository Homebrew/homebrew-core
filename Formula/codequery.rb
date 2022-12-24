class Codequery < Formula
  desc "Code-understanding, code-browsing or code-search tool"
  homepage "https://github.com/ruben2020/codequery"
  url "https://github.com/ruben2020/codequery/archive/refs/tags/v0.26.0.tar.gz"
  sha256 "5972a5778159835e37f5c9114a90f1be4756f27487d9074d2fb3464625a0ced2"
  license "MPL-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "b9c8ec8d80cf9212ffcf7baa2d1cbe299e17ccafe08567d5fb020d37d76f40e8"
    sha256 cellar: :any,                 arm64_monterey: "e81a2e4210a2ce35fc870bab1c41342735f0c6e9317d56ee9eab7a17ea32f7f5"
    sha256 cellar: :any,                 arm64_big_sur:  "618adda8c69f88e2fb9cce010dd9c9e862eeae9a1117f9492f9ae6043e12086f"
    sha256 cellar: :any,                 ventura:        "aaac676a83dbe38c487d537d3a2cd942f1d47179aa8d5e4a37088a675596237d"
    sha256 cellar: :any,                 monterey:       "61459d0b4467e459b04450e207fb7a969fe9fb0005e56f669815573c6c892f61"
    sha256 cellar: :any,                 big_sur:        "914b33a4baaebcc8aad026abe9c85d71830b10c17edab8b1b4fbe00ef8a88ff6"
    sha256 cellar: :any,                 catalina:       "4910a7cb4de7100322ae686f0bdc4146424f46cbd978257d28102d2a362dd90d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7dd62492b5cf3d9e4fb7626acdfd868ba583636964d8399ba39a5ecd6cb0950"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "qt@5"

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
