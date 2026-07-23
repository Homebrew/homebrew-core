class Edbrowse < Formula
  desc "Command-line editor and web browser"
  homepage "https://edbrowse.org"
  url "https://github.com/edbrowse/edbrowse/archive/refs/tags/v3.8.17.tar.gz"
  sha256 "676f6d74fc3d7a52f3633318f8220092fd824ae518efeb1996b8f51c533dd2fa"
  license "GPL-2.0-or-later"
  head "https://github.com/edbrowse/edbrowse.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "bc52aecbc691e1e62d46d61f76c6dc4dccc777ca2028b8f3eec3b82db4216198"
    sha256 cellar: :any, arm64_sequoia: "af590e4e5d9ace3bbc92f8a67f3aa181a76f426240829ae4638d653c86388bf4"
    sha256 cellar: :any, arm64_sonoma:  "ad95e56d3153d115a9015076aa9f021ea60f2f2e5efb01ecca73bc21f9451a87"
    sha256 cellar: :any, sonoma:        "ecd9cbc3c1b34a2fca4b40ee5440371ae85f9ba5835a9b5d0c97fd9393227797"
    sha256 cellar: :any, arm64_linux:   "2a9a20dc489518aff7578f1de37e857f077abf31a312b41c0780c930cd6e179a"
    sha256 cellar: :any, x86_64_linux:  "e2f021419fd975f3353dd311821655ee0a4cc5b60a445ae271a3e80a79e56b54"
  end

  depends_on "pkgconf" => :build
  depends_on "quickjs" => :build
  depends_on "curl"
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "readline"
  depends_on "unixodbc"

  def install
    # :: is a GNU make operator, but BSD make doesn't support it
    inreplace "src/makefile", "::=", ":="

    ENV.append_to_cflags "-DQ_NG=0"

    cd "src" do
      make_args = [
        "QUICKJS_INCLUDE=#{formula_opt_include("quickjs")}/quickjs",
        "QUICKJS_LIB=#{formula_opt_lib("quickjs")}/quickjs",
        "QUICKJS_LIB_NAME=quickjs",
      ]

      system "make", *make_args
      system "make", "install", "PREFIX=#{prefix}"
    end
  end

  test do
    (testpath/".ebrc").write("")
    (testpath/"test.txt").write("Hello from ed\n")

    system "printf %s\\\\n 's/ed/edbrowse/' 'w' 'q' | #{bin}/edbrowse -c .ebrc test.txt"
    assert_equal "Hello from edbrowse", (testpath/"test.txt").read.chomp
  end
end
