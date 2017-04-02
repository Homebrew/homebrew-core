class Codequery < Formula
  desc "Code-understanding, code-browsing or code-search tool."
  homepage "https://github.com/ruben2020/codequery"
  url "https://github.com/ruben2020/codequery/archive/v0.18.1.tar.gz"
  sha256 "482fa737691c260e16adcc32bc3fd43ba50a309495faec6b2f3098b517e6c0e9"
  revision 2

  bottle do
    cellar :any
    sha256 "0a69d079240d98269069d0c38ca1579685084d975cf6c3e49e92554e2562e0a7" => :sierra
    sha256 "7b305f7a624567e92d16637863d6d8c16946e8df22ece7502d5bd187a5e8517e" => :el_capitan
    sha256 "d21a56640656f08060dd3c9e8b1800808f314e90f003a7d51158deb6be5f2a6e" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "qt5"
  depends_on "qscintilla2"

  def install
    args = std_cmake_args
    args << "-DBUILD_QT5=ON"
    args << "-DQT5QSCINTILLA_LIBRARY=#{Formula["qscintilla2"].opt_lib}/libqscintilla2_qt5.dylib"

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
