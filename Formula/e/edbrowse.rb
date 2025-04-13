class Edbrowse < Formula
  desc "Command-line editor and web browser"
  homepage "https://edbrowse.org"
  url "https://github.com/CMB/edbrowse/archive/refs/tags/v3.8.11.tar.gz"
  sha256 "7c614d50e89245d3caf48189954dcf9988427e2953c0eaeea622fe38f19ceb44"
  license "GPL-2.0-or-later"
  head "https://github.com/cmb/edbrowse.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "ddf8e9062118e87b24ff681347d0e122e3a499d8b40b7326024fb95e93d344b0"
    sha256 cellar: :any,                 arm64_sonoma:  "bb81adde1c00441159779d788f80f0c8c3c73ac760059aff4228a675b7836e82"
    sha256 cellar: :any,                 arm64_ventura: "568669e578e237542fdba1ca66b063324e35eabbbd2079e4e5f2b0c8ab8173d7"
    sha256 cellar: :any,                 sonoma:        "f4520decc1445d3e8bee5943f813cf0c1ed3a810ef2bd3279f94eeec88588e92"
    sha256 cellar: :any,                 ventura:       "662a7d9f45f93dbb8ad25b033e12d21c9b3a887514881c5c7965a358d2344604"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a388751f14db94d8429adcf63fbb39cd7f697b183d935efea406282b95e09c12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2d444a2126e9605d840be0eba26d63f846cc4a88d6c590f918cdff6a9d8aa289"
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
