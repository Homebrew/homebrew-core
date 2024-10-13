class Edbrowse < Formula
  desc "Command-line editor and web browser"
  homepage "https://edbrowse.org"
  url "https://github.com/CMB/edbrowse/archive/refs/tags/v3.8.10.tar.gz"
  sha256 "3c194ce45b7348211ce3ad8e3304a0eacf8b27e623cbf8c08687785f88174e03"
  license "GPL-2.0-or-later"
  head "https://github.com/cmb/edbrowse.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "d2824e9e8c3391b47d6ad414b0b45256b5f857a9a8d1a0cb1c1760739223245f"
    sha256 cellar: :any,                 arm64_sonoma:   "2eee1c0542e0ded8ffe313fb87b85163f196a66e7f71f60095a9334ef868d676"
    sha256 cellar: :any,                 arm64_ventura:  "5474ecc1ac83b2105d4903ff021177e342bf836ee8cbbc9478bb82b9791b1124"
    sha256 cellar: :any,                 arm64_monterey: "f315ec5cbc69a61ca9ab3a9ebb5b60d72a3ad1ae83ff4ef66d342bdba33152a9"
    sha256 cellar: :any,                 sonoma:         "1676e0f9d76fa15be36fdccb36642339a687dc0934a5264c16de342c012489ae"
    sha256 cellar: :any,                 ventura:        "b636c25683db853afd169a8e7f71df6cd469746bddd8b5724bf89167528ea353"
    sha256 cellar: :any,                 monterey:       "97bafb01fc2aea63b9dba3a79ffd5aed0206402751e6133ce3713c1c6ccb85f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e500898284f9a555e06cae23b9329e734825dcb1c1fc743327ee51584a226f9"
  end

  depends_on "pkg-config" => :build
  depends_on "quickjs" => :build
  depends_on "curl"
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "readline"
  depends_on "unixodbc"

  def install
    cd "src" do
      make_args = [
        "QUICKJS_INCLUDE=#{Formula["quickjs"].opt_include}/quickjs",
        "QUICKJS_LIB=#{Formula["quickjs"].opt_lib}/quickjs",
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
