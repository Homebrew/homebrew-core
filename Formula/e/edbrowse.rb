class Edbrowse < Formula
  desc "Command-line editor and web browser"
  homepage "https://edbrowse.org"
  url "https://github.com/CMB/edbrowse/archive/refs/tags/v3.8.9.tar.gz"
  sha256 "dae133d6b52be88864f8e696b8fc4ca4185e04857707713da8a0085bedf04e6b"
  license "GPL-2.0-or-later"
  head "https://github.com/cmb/edbrowse.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0e6147227b28ca722afba756e65977d242fb594bddad95acab592e51044ad0c9"
    sha256 cellar: :any,                 arm64_ventura:  "68abdec2ccee5beff81db1eafed9280c7095c5e44044e5ee6cb9ed3b4841010c"
    sha256 cellar: :any,                 arm64_monterey: "bd396a7548fb8f31b7e818e83d2e328645423d551649a42f30afed32c1eb52c1"
    sha256 cellar: :any,                 sonoma:         "af105c01c0156a17be0ff73be5d76bfc8b94dc6879b7d2f785851919bfc35923"
    sha256 cellar: :any,                 ventura:        "f03710f043b662a2a98a3b4145acd5f3c2706920879bb9267a09711955e85ae4"
    sha256 cellar: :any,                 monterey:       "28faa029621626599bd8c9056d428c517ef3ba0fdaa1c9b990cf9f313128e477"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7590823737c1ed2fa8a7859619c4bae0b2994e9e20b193dc81258c3266651e1"
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
