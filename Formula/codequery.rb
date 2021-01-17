class Codequery < Formula
  desc "Code-understanding, code-browsing or code-search tool"
  homepage "https://github.com/ruben2020/codequery"
  url "https://github.com/ruben2020/codequery/archive/v0.24.0.tar.gz"
  sha256 "39afc909eae3b0b044cefbbb0e33d09e8198a3b157cf4175fceb5a22217fe801"
  license "MPL-2.0"

  bottle do
    cellar :any
    sha256 "7f8c243f0fc8d33c04ed5ec3579a85d1c39802c4cafd05df0b83a34a1d6edc47" => :big_sur
    sha256 "b4412d85b3db4b9f51af79da9b5adcc172bcf9448d5b6e45b272da764751a37a" => :arm64_big_sur
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
