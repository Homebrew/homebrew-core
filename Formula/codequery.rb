class Codequery < Formula
  desc "Code-understanding, code-browsing or code-search tool"
  homepage "https://github.com/ruben2020/codequery"
  url "https://github.com/ruben2020/codequery/archive/v0.24.0.tar.gz"
  sha256 "39afc909eae3b0b044cefbbb0e33d09e8198a3b157cf4175fceb5a22217fe801"
  license "MPL-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "fd2941c284a98300e9e5a1a97d4c548d3b421d56816ae19610de0d53b8d53d99"
    sha256 cellar: :any,                 arm64_big_sur:  "b6911db7943e77b1da9e37997f578c3d66b8f2fbefee757f343dcc180b88d9bd"
    sha256 cellar: :any,                 monterey:       "1b6df250a388c520c73b6549b4f9ee0411ab788720d5d5ff01f3a4e53af477e1"
    sha256 cellar: :any,                 big_sur:        "1fe79b4632dd2e794bb09758ce9a776b7b751dddf4fd03ff47eeb0c79d16f729"
    sha256 cellar: :any,                 catalina:       "feca768a985ac4578a99290c1070b8f1dfe0716017da89a1b6f01e9ae7685acd"
    sha256 cellar: :any,                 mojave:         "c49d64f50a33ecc8de70d9431dab346d40de6f0fdc077b826d24b19db9cba99b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7be6092fc351e20b9d4223550a672ac80b03f6a31bcca70b607d7115156260b3"
  end

  depends_on "cmake" => :build
  depends_on "qt@5"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    args = std_cmake_args
    args << "-DBUILD_QT5=ON"

    share.install "test"
    mkdir "build" do
      system "cmake", "..", "-G", "Unix Makefiles", *args
      system "make"
      system "make", "install"
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
