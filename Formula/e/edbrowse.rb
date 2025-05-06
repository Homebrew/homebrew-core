class Edbrowse < Formula
  desc "Command-line editor and web browser"
  homepage "https://edbrowse.org"
  url "https://github.com/CMB/edbrowse/archive/refs/tags/v3.8.12.tar.gz"
  sha256 "b5125c7d13c2ed4491dc0d5a31116b244db62ae1c417ba5d29910311d1194632"
  license "GPL-2.0-or-later"
  head "https://github.com/cmb/edbrowse.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1059c249fdc4473bb94aecdb88165610ce77bb5ac7ef3b0f305de0547b9f95e2"
    sha256 cellar: :any,                 arm64_sonoma:  "61776b8d57d723fa908d7adbd7e4809ddb74cf6d79dcb328bca7d968f53efdcc"
    sha256 cellar: :any,                 arm64_ventura: "b2f567f1855a2f083486a0071ed7ee99c722262baa9da61490b5dc7d2a2f2343"
    sha256 cellar: :any,                 sonoma:        "fa304945f90088cd4376c092d1c37757e50849b8d3c23f773311f0ae10dd31d3"
    sha256 cellar: :any,                 ventura:       "65f9a2871c07b22ec5a62bd1b1ad344c3fe83758b5f54607cf9df0dd657ebd34"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "19e13259385a839bc97d2a8c915b071c7bcd52ccd197ad0f8612564db33ae57d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1b5862d17d78723f9685cf613663b788c0430e86ee8accb80f5182ed800fa16"
  end

  depends_on "pkgconf" => :build
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
