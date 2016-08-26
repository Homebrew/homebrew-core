class Codequery < Formula
  desc "Index, query, or search C, C++, Java, Python, Ruby, or Go code"
  homepage "https://github.com/ruben2020/codequery"
  url "https://github.com/ruben2020/codequery/archive/v0.16.0.tar.gz"
  sha256 "4896435a8aa35dbdca43cba769aece9731f647ac9422a92c3209c2955d2e7101"
  revision 2

  bottle do
    cellar :any
    sha256 "efcc6f507735a404c8699276c140bdf776ae894aa3e636597ba83000c1e8a55d" => :el_capitan
    sha256 "840c8bfe119700cbc567d73d597876289892a615b1c25147b1d5a879d37c9625" => :yosemite
    sha256 "283dac43dac39b2e03699cd80157cf24d8ff30d6186a0493bafc70d13b1f013e" => :mavericks
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
