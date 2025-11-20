class Ncmdump < Formula
  desc "Convert Netease Cloud Music ncm files to mp3/flac files"
  homepage "https://github.com/taurusxin/ncmdump"
  url "https://github.com/taurusxin/ncmdump/archive/refs/tags/1.5.1.tar.gz"
  sha256 "35062836d5210718b12fd311535f4673f5db4de18bd8e987890d89fc0e0a7e6c"
  license "MIT"
  head "https://github.com/taurusxin/ncmdump.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "99795c0e507a0a64b449c2688217ce0de2831260055765dbe37f56669c1ff9c7"
    sha256 cellar: :any,                 arm64_sequoia: "e29cbd06aef33319b016e7b1013c6e1d72432cd1de0382994bb486be26c0268a"
    sha256 cellar: :any,                 arm64_sonoma:  "9a6f52ab49f6d4ff627357f662192b2fca298ce66a9e51381ef87af6412fcc16"
    sha256 cellar: :any,                 sonoma:        "ea72a6147d57e098312ea81119a4dd08b12464241db780a2ebaa0e7876c20189"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f95e343c040760559382f6cb2b8f7bf9199cb14be12b0e72fda4538dd605c2dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c4e754f69b305837012bc328cef7db9834483cf849a2a12c3d6a8f1e122636b"
  end

  depends_on "cmake" => :build
  depends_on "taglib"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    resource "homebrew-test" do
      url "https://raw.githubusercontent.com/taurusxin/ncmdump/516b31ab68f806ef388084add11d9e4b2253f1c7/test/test.ncm"
      sha256 "a1586bbbbad95019eee566411de58a57c3a3bd7c86d97f2c3c82427efce8964b"
    end

    resource("homebrew-test").stage(testpath)
    system bin/"ncmdump", "#{testpath}/test.ncm"
    assert_path_exists testpath/"test.flac"
  end
end
