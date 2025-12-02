class Edbrowse < Formula
  desc "Command-line editor and web browser"
  homepage "https://edbrowse.org"
  url "https://github.com/edbrowse/edbrowse/archive/refs/tags/v3.8.15.tar.gz"
  sha256 "17c19179ec659a560ca4070103f2db37d29b71bc5d483c5f9d8a616abbfeb190"
  license "GPL-2.0-or-later"
  head "https://github.com/edbrowse/edbrowse.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1f283ccbdfc824f65026829fafcdea0489ba67d1bd814e1efa63188028469e62"
    sha256 cellar: :any,                 arm64_sequoia: "3bab6f02f68660fbc7ef7d8d10bc5beab31c9037a8e4e93338794ffc4eb3e450"
    sha256 cellar: :any,                 arm64_sonoma:  "f3d60bbe8c842555381664a2a4341a1b47a1f970e0b61fa2cc2932d99a2d3ba7"
    sha256 cellar: :any,                 sonoma:        "66d4cbf1ebe89017c5e6d34f43e2ed762f44f9fa09ac37873027cd745bc401a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "93d8f4080bf66e3e9d517fde6abece60a888c39bd01c341b3da18c55ba171695"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e312149ee61414e925b221f95fdfab83758c6d6ddcedb404bf0713b5f1320fae"
  end

  depends_on "pkgconf" => :build
  depends_on "quickjs" => :build
  depends_on "curl"
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "readline"
  depends_on "unixodbc"

  def install
    ENV.append_to_cflags "-DQ_NG=0"

    cd "src" do
      make_args = [
        "QUICKJS_INCLUDE=#{Formula["quickjs"].opt_include}/quickjs",
        "QUICKJS_LIB=#{Formula["quickjs"].opt_lib}/quickjs",
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
