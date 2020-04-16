class Codequery < Formula
  desc "Code-understanding, code-browsing or code-search tool"
  homepage "https://github.com/ruben2020/codequery"
  url "https://github.com/ruben2020/codequery/archive/v0.23.0.tar.gz"
  sha256 "c8d1cac148de8979fa4fb4455edc7610e36519503bf9848b6edd008b00c41690"

  bottle do
    cellar :any
    sha256 "b3f585e17783444968f0739397eb41fb14f897584118689bf1dbb862344e4221" => :catalina
    sha256 "94fd84eb8c088b69eeddd1e09ad6bf7ed97ddd052e2ab4f6381776a6b4d3622d" => :mojave
    sha256 "da150e36ca0d9cc56f7b243aa26677e4bed67335b1be5d01f10eeaf83df6884b" => :high_sierra
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
