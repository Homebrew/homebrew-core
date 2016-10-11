class Codequery < Formula
  desc "Index, query, or search C, C++, Java, Python, Ruby, Go and Javascript code"
  homepage "https://github.com/ruben2020/codequery"
  url "https://github.com/ruben2020/codequery/archive/v0.18.0.tar.gz"
  sha256 "1beacde7c84059c1a62d3ccf6bc7fa9c11336f9df95edc358e7e09eceec0fc42"

  bottle do
    cellar :any
    sha256 "902fc914dc635862d8b464b7428249b9a21ed8fe5cea4d7809cbaed5c0c74662" => :el_capitan
    sha256 "eecdc4016192b2a8c35874d6996e8a43288775dcdfd0691f73ed288662f0d109" => :yosemite
    sha256 "0b2628d4c0c39cf81c66605acb587864e0590b69130ec28719b0b1c821e57682" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "qt5"
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
