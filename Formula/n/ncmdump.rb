class Ncmdump < Formula
  desc "Convert Netease Cloud Music ncm files to mp3/flac files"
  homepage "https://github.com/taurusxin/ncmdump"
  url "https://github.com/taurusxin/ncmdump/archive/refs/tags/1.5.0.tar.gz"
  sha256 "f59e4e5296b939c88a45d37844545d2e9c4c2cd3bb4f1f1a53a8c4fb72d53a2d"
  license "MIT"
  head "https://github.com/taurusxin/ncmdump.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "5cb059fc2cc8ec831eef8e54ccbf72efbada242917cbe95ce19b33a129ba6949"
    sha256 cellar: :any,                 arm64_sonoma:   "6b6ea8422cf6c07ba41cdec25cd75e74881a0b9d131ca4fc4e7fa5a36a45ccae"
    sha256 cellar: :any,                 arm64_ventura:  "78c634b892549c682cd00c6962208eb52b451c184356d7d1629f6c1206beeab3"
    sha256 cellar: :any,                 arm64_monterey: "af2c32f41f65892c7b8d2e09972e438827624e440d438d65ec13c56508f8445c"
    sha256 cellar: :any,                 sonoma:         "62112dfde17a6a5e81071383e42befcb8b29660ccc4851dcb62209d9f2aeb8be"
    sha256 cellar: :any,                 ventura:        "05583fb35e51d6227ba2dbfd43052a60a362af345ae7e70a9acf284404bda5db"
    sha256 cellar: :any,                 monterey:       "157a0d4a3b8860df60878495e101b2264eb5e2c740e3fa1232af96f945667b79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ef82870ff5763efecb19096dd73cc4090c392d694cdce5e4e1d22cd169cb568"
  end

  depends_on "cmake" => :build
  depends_on "taglib"

  def install
    inreplace "CMakeLists.txt", "add_subdirectory(taglib)\n", ""
    inreplace buildpath/"src/ncmcrypt.cpp" do |s|
      s.gsub! "#define TAGLIB_STATIC\n", ""
      s.gsub! "#include \"taglib/tag.h\"", "#include <taglib/tag.h>"
      s.gsub!(%r{#include "taglib/.*/(.*)\.h"}, '#include <taglib/\1.h>')
    end

    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_PREFIX_PATH=#{Formula["taglib"].opt_prefix}", *std_cmake_args
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
