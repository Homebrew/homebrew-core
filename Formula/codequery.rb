class Codequery < Formula
  desc "Code-understanding, code-browsing or code-search tool"
  homepage "https://github.com/ruben2020/codequery"
  url "https://github.com/ruben2020/codequery/archive/v0.23.0.tar.gz"
  sha256 "c8d1cac148de8979fa4fb4455edc7610e36519503bf9848b6edd008b00c41690"

  bottle do
    cellar :any
    sha256 "45bcd6dfe541e18dcec19044b05bd1f50e56f48ef46b91013e9279301176e1cc" => :catalina
    sha256 "1e5fcb01cf9e8ae18b0673322b682153b029ca59ca9c50dd2685be360c61772f" => :mojave
    sha256 "40193a3269ec436ddcb36a6aa1d70851c6cd7cd905fa92e1ee10d5e44387702e" => :high_sierra
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
