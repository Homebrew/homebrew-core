class Ncmdump < Formula
  desc "Convert Netease Cloud Music ncm files to mp3/flac files"
  homepage "https://github.com/taurusxin/ncmdump"
  url "https://github.com/taurusxin/ncmdump/archive/refs/tags/1.5.0.tar.gz"
  sha256 "f59e4e5296b939c88a45d37844545d2e9c4c2cd3bb4f1f1a53a8c4fb72d53a2d"
  license "MIT"
  head "https://github.com/taurusxin/ncmdump.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9b8b18693e23e28c86536d252255072708216e857cd2e8e7102551dbbd07e4ea"
    sha256 cellar: :any,                 arm64_sonoma:  "6cc0adacd3083f40ad30cf8ea914f508c23e1720d23020775d914011615dffc3"
    sha256 cellar: :any,                 arm64_ventura: "50fe70048df8144284e69b364daa834e073dddae300321bfec326d076d7f4733"
    sha256 cellar: :any,                 sonoma:        "6ce7bd73a815fe8a87ea4edf1df074ab29f5b57793888f7f45b8f08d5146617c"
    sha256 cellar: :any,                 ventura:       "08a148b759c425f00c14dd9a47e488e81654e6cd8a3473488ca1d91529e07b6b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "73fb1e271e16219093c407dabfafedf583fe4d1665ae2aa0d0886e883ac703ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77421b520db321edb6b48416603b3c3ffc1319d4c3937ca0bd067e344662caa5"
  end

  depends_on "cmake" => :build
  depends_on "taglib"

  def install
    # Use Homebrew's taglib
    # See discussion: https://github.com/taurusxin/ncmdump/discussions/49
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
