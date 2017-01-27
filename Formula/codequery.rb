class Codequery < Formula
  desc "Index, query, or search C, C++, Java, Python, Ruby, Go and Javascript code"
  homepage "https://github.com/ruben2020/codequery"
  url "https://github.com/ruben2020/codequery/archive/v0.18.1.tar.gz"
  sha256 "482fa737691c260e16adcc32bc3fd43ba50a309495faec6b2f3098b517e6c0e9"
  revision 1

  bottle do
    cellar :any
    sha256 "f8bfbac52963d68ed6ab81e022a8fd0c45548dac6b5cf95ef73437aafa556edf" => :sierra
    sha256 "04df25b8ab1113897094db9d0519a1f28ce1ba9689c2597486819713464a1d53" => :el_capitan
    sha256 "a2309154fc40df49a175b81755644b9ffceb1d7805a2ea9e22c37375c51c23bd" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "qt@5.7"
  depends_on "qscintilla2"

  def install
    args = std_cmake_args
    args << "-DBUILD_QT5=ON"
    args << "-DQT5QSCINTILLA_LIBRARY=#{Formula["qscintilla2"].opt_lib}/libqscintilla2.dylib"

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
