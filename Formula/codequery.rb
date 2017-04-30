class Codequery < Formula
  desc "Code-understanding, code-browsing or code-search tool."
  homepage "https://github.com/ruben2020/codequery"
  url "https://github.com/ruben2020/codequery/archive/v0.21.0.tar.gz"
  sha256 "9af232e0d3bb10e5defbc222a9e422f4580dd5766cfc7f921d38baa18675f98d"

  bottle do
    cellar :any
    sha256 "d5c1e9eefa84126c439d9c37b2a12d4cbe542052e8ac8cff44fbe6244936d32e" => :sierra
    sha256 "30006fb55abc47394305bd19dc263dfaab7431d32473b26c5c0644883f109d1a" => :el_capitan
    sha256 "a0399896f4481f772d03f4472e03f7f4a445cfae26eb356244755ab3633241cd" => :yosemite
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
