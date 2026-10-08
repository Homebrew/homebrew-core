class Edbrowse < Formula
  desc "Command-line editor and web browser"
  homepage "https://edbrowse.org"
  url "https://github.com/edbrowse/edbrowse/archive/refs/tags/v3.8.18.tar.gz"
  sha256 "fde2fceceeb08befa23289e76f6e8a22a7ba87b77dca79b165adfb4170a98629"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/edbrowse/edbrowse.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "1759d73f0e098135066c153e62ecf099d21d0ac185ec0f9575b84d85d24cf5f6"
    sha256 cellar: :any, arm64_tahoe:       "aa5a3e99848664ed7e3c231b63cb9b21233ba6cdba3032f16cebc115359b64a3"
    sha256 cellar: :any, arm64_sequoia:     "e37bb3bbf964b36027805e90f8ea7dcbb4fb8c8503df7b518d0529c5a73e166c"
    sha256 cellar: :any, arm64_linux:       "38ffcd24b275a496e60a80348393474b23b7a3592c1d007c7868bcd80822b056"
    sha256 cellar: :any, x86_64_linux:      "900dbc4d18264ef34ad23827f78b8c08d836e05ea76b1940829229d1af3317d8"
  end

  depends_on "pkgconf" => :build
  depends_on "quickjs" => :build
  depends_on "curl"
  depends_on "openssl@4"
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
