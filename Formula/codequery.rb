class Codequery < Formula
  desc "Code-understanding, code-browsing or code-search tool."
  homepage "https://github.com/ruben2020/codequery"
  url "https://github.com/ruben2020/codequery/archive/v0.21.0.tar.gz"
  sha256 "9af232e0d3bb10e5defbc222a9e422f4580dd5766cfc7f921d38baa18675f98d"

  bottle do
    cellar :any
    sha256 "cf8477f991795c39b7993c3eab785eb5b069c684db0c0d24d08777faee44993b" => :sierra
    sha256 "f9c4cf1314b4c84622ea4dd3f8950e683cf2030f6bdb5b1ea63374ea7bc25a74" => :el_capitan
    sha256 "5b80bb8794e765c0436ee8abe8ac667813f42810a12dccccabe909a8b0733496" => :yosemite
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
