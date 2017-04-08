class Codequery < Formula
  desc "Code-understanding, code-browsing or code-search tool."
  homepage "https://github.com/ruben2020/codequery"
  url "https://github.com/ruben2020/codequery/archive/v0.19.0.tar.gz"
  sha256 "c8fbb133ec281cdc58d81824a1d3b1761e5496fcfd37229e68060beb0e0c7fc9"
  revision 1

  bottle do
    cellar :any
    sha256 "048cefd89ef9f6701045ed89515d294dbcf1dc97881cea0c2a0dea1608ccb961" => :sierra
    sha256 "a1a531716d96263ac8f277e0353079773697358719db22cf634659fd9e04aff6" => :el_capitan
    sha256 "88c61e418dd6e065737a64f87c4d9611a2d3eb0cfb69fd02deacd58d16f6b43c" => :yosemite
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
