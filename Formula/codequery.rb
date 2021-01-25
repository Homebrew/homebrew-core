class Codequery < Formula
  desc "Code-understanding, code-browsing or code-search tool"
  homepage "https://github.com/ruben2020/codequery"
  url "https://github.com/ruben2020/codequery/archive/v0.24.0.tar.gz"
  sha256 "39afc909eae3b0b044cefbbb0e33d09e8198a3b157cf4175fceb5a22217fe801"
  license "MPL-2.0"

  bottle do
    cellar :any
    sha256 "6882e0c73522ed885c8019728345d715f052131a977c2fcb412719f291067c2a" => :big_sur
    sha256 "e878297e7d2e9199a0524a9de866b5d98c49746449bd34829cb2df1ad8062466" => :arm64_big_sur
    sha256 "3e65dd4fdeca53a31d87f1de5cf2957624797575773a25a650e6899b33803056" => :catalina
    sha256 "b8ef06cdace299c0ac728ae6cfc29d4b7d9eee89ed80e9f04797e5e9b21db83b" => :mojave
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
