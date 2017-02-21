class Codequery < Formula
  desc "Code-understanding, code-browsing or code-search tool."
  homepage "https://github.com/ruben2020/codequery"
  url "https://github.com/ruben2020/codequery/archive/v0.18.1.tar.gz"
  sha256 "482fa737691c260e16adcc32bc3fd43ba50a309495faec6b2f3098b517e6c0e9"
  revision 2

  bottle do
    cellar :any
    sha256 "ade7464d5b27d9c9882af9476e3c194971311b3903477905058a1ea4b9a690c0" => :sierra
    sha256 "8c34fe37f022bc659c7860cc948a631f5654a03f4a1a334b83817872d46653e4" => :el_capitan
    sha256 "1063c272ba906493a32666e25d4b014ae3df86c9fb056870c3342beacb7b4b3f" => :yosemite
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
