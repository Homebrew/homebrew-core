class Joe < Formula
  desc "Full featured terminal-based screen editor"
  homepage "https://joe-editor.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/joe-editor/JOE%20sources/joe-4.7/joe-4.7.tar.gz"
  sha256 "712b23a83a3757a93d2b4a76325b9dabba554c182b209d2675537c272867fcba"
  license "GPL-1.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/joe[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_tahoe:   "d1c7b5584cac5808c35360d93715a1213eaac29acad6620404c14e9c05cecd69"
    sha256 arm64_sequoia: "47383d58059171652e3bc640430f7ed0315889e2335da8e5eca24d37d38acce9"
    sha256 arm64_sonoma:  "7cd44608926719abfc378287733307637efbdf065df213a7176b3156cbff5e59"
    sha256 sonoma:        "d25c35b7caf21b3980f97ac39e4d5ff1b9a754a3c462dc717d39de9269a17ac8"
    sha256 arm64_linux:   "9ff0f191b7bc1b1c83d08f1c35d23e271c950275a8eb753b4d32b42ce172698c"
    sha256 x86_64_linux:  "5dfe1e49be8d02bdc6a2b2edda542344610182c2ef59b8685a2d6667475c1cc5"
  end

  conflicts_with "jupp", because: "both install the same binaries"

  def install
    # fix implicit declaration errors https://sourceforge.net/p/joe-editor/bugs/408/
    inreplace "joe/tty.c", "#include \"types.h\"", "#include \"types.h\"\n#include <util.h>" if OS.mac?

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "Joe's Own Editor v#{version}", shell_output("TERM=tty #{bin}/joe -help")
  end
end
