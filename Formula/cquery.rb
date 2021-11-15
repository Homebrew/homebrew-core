class Cquery < Formula
  desc "C/C++ language server"
  homepage "https://github.com/cquery-project/cquery"
  # pull from git tag to get submodules
  url "https://github.com/cquery-project/cquery.git",
      tag:      "v20180718",
      revision: "b523aa928acf8ffb3de6b22c79db7366a9672489"
  license "MIT"
  head "https://github.com/cquery-project/cquery.git", branch: "master"

  bottle do
    rebuild 1
    sha256 monterey:     "325a5c3bfe7522d659813c0a3ced06aef240dae2876d815bf8f1341d08a69342"
    sha256 big_sur:      "92e25635f16f15c7c34222616b2c4f33ba5605e16c010fb3ee9be24a7c8adab9"
    sha256 catalina:     "fc7c73b7d9132c879399fc65a3556d9382d9617dd5e59bc10a51eaed228be5f8"
    sha256 mojave:       "89a896183bd8e6635146263dc09c0f26464845f91637e5ca9557558aaa034139"
    sha256 high_sierra:  "555804325cb45d5450c0d8b47096b71b8445af5370a9fc1e71acb1a6e86d3398"
    sha256 x86_64_linux: "96e88524a7f8a2e63b5e8bc825e3ec59a052a0577a6b4b4b91943cf16ec160ae"
  end

  deprecate! date: "2020-11-15", because: :repo_archived

  depends_on "cmake" => :build
  depends_on "llvm"

  # error: 'shared_timed_mutex' is unavailable: introduced in macOS 10.12
  depends_on macos: :sierra

  def install
    system "cmake", ".", "-DSYSTEM_CLANG=ON", *std_cmake_args
    system "make", "install"
  end

  test do
    system bin/"cquery", "--test-unit"
  end
end
