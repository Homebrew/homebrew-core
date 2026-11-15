class Edbrowse < Formula
  desc "Command-line editor and web browser"
  homepage "https://edbrowse.org"
  url "https://github.com/edbrowse/edbrowse/archive/refs/tags/v3.8.19.tar.gz"
  sha256 "8ebfd92b5200e8b2190e104b9ce4edd6e3c38276449716cfc69705bf71c891a3"
  license "GPL-2.0-or-later"
  head "https://github.com/edbrowse/edbrowse.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "eabfa6d7248309229f53a8a741ecfe6e0f17c4e4b0f2755452e611cbb1e1c834"
    sha256 cellar: :any, arm64_tahoe:       "b7c09aa2a5a9b9571b538c521dbc14fbaaca6345918a91ce028eeb0aef96a32b"
    sha256 cellar: :any, arm64_sequoia:     "3f944dba1a34bed36269aaeebfdb8c8c4121ebae945bb44d6cd9189efadebb16"
    sha256 cellar: :any, arm64_linux:       "7ade4310f8c98639c4558c7bf056c0bd9198da3d475abe70519b4707506745bf"
    sha256 cellar: :any, x86_64_linux:      "3df0d1bedb1a06a4a6be76223cc4206e527e5e68b87384466bb5ee94a359c611"
  end

  depends_on "pkgconf" => :build
  depends_on "curl"
  depends_on "openssl@4"
  depends_on "pcre2"
  depends_on "quickjs-ng"
  depends_on "readline"
  depends_on "unixodbc"

  def install
    # :: is a GNU make operator, but BSD make doesn't support it
    inreplace "src/makefile", "::=", ":="

    # `malloc_size` is declared in <malloc/malloc.h> on macOS
    inreplace "src/jseng-quick.c", "#include <malloc.h>", "#include <malloc/malloc.h>" if OS.mac?

    cd "src" do
      make_args = [
        "QUICKJS_INCLUDE=#{formula_opt_include("quickjs-ng")}",
        "QUICKJS_LIB=#{formula_opt_lib("quickjs-ng")}",
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
