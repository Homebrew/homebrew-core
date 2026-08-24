class Edbrowse < Formula
  desc "Command-line editor and web browser"
  homepage "https://edbrowse.org"
  url "https://github.com/edbrowse/edbrowse/archive/refs/tags/v3.8.18.tar.gz"
  sha256 "fde2fceceeb08befa23289e76f6e8a22a7ba87b77dca79b165adfb4170a98629"
  license "GPL-2.0-or-later"
  head "https://github.com/edbrowse/edbrowse.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "67a34ec5929622304a0a9314e7701edb9ee8149fe00556b05421cdbc91560138"
    sha256 cellar: :any, arm64_sequoia: "a71d976e8437fcb66f651b9a3ae887aca434c1c787c041694591bd182a024fc1"
    sha256 cellar: :any, arm64_sonoma:  "12dd81f869ad85b71af60d247a5b485c8fc4f05fd78d9ce52c6670062b7e7bd6"
    sha256 cellar: :any, sonoma:        "f77ef43197f3a7f82b26469c4b84abbc632a99b478e7b8d5e90e78856bd6bb0a"
    sha256 cellar: :any, arm64_linux:   "84613edf13399a3d74a72c478a10a707f7d72ff9a31f42bb5b6202c263874d25"
    sha256 cellar: :any, x86_64_linux:  "b56c0b498489b3049ece4ae872b3944acf417ef2cf83b999b82d58e42d8bb70c"
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
