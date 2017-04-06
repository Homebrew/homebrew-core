class Codequery < Formula
  desc "Code-understanding, code-browsing or code-search tool."
  homepage "https://github.com/ruben2020/codequery"
  url "https://github.com/ruben2020/codequery/archive/v0.19.0.tar.gz"
  sha256 "c8fbb133ec281cdc58d81824a1d3b1761e5496fcfd37229e68060beb0e0c7fc9"
  revision 1

  bottle do
    cellar :any
    sha256 "7891ec24972adf76df868c0a67d1407e005683530b56ea52cea0a7acc3ddd0c8" => :sierra
    sha256 "c06e0d6e41de521001c647a20012683c6d91d1ed5eb2d6abe8fef312203236bb" => :el_capitan
    sha256 "56bddde5976a54be551b3295b82eab02aa16e9497c392e8c5f69b4816e5705fd" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "qt"

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
