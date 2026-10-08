class Chawan < Formula
  desc "TUI web browser with CSS, inline image and JavaScript support"
  homepage "https://sr.ht/~bptato/chawan/"
  url "https://git.sr.ht/~bptato/chawan/archive/v0.4.4.tar.gz"
  sha256 "e0a06e1504e10a51c6009751d79b798c98d8274e559fe195d4b4b7ddadf91bb8"
  license "Unlicense"
  revision 1
  head "https://git.sr.ht/~bptato/chawan", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "f97c63489c18cccfb6d28f13130f6823ebad3e118343b4c1b0899109f5d15add"
    sha256 cellar: :any, arm64_tahoe:       "d59c7f3caf8b0f20cce4edab58c7960283d283b9317bd4d695ab56b4851027ca"
    sha256 cellar: :any, arm64_sequoia:     "7438d5fec7680b87fecec1ded1b75008cfdeb59f52686cb49a75b522d7ce6341"
    sha256 cellar: :any, arm64_linux:       "617bb5816855da3f6d9de1d8234c86273d5bbf75b81d274e3072f1b7f778a2e0"
    sha256 cellar: :any, x86_64_linux:      "f261456355ffd75d31c1872c3bade32bd5a0b14bc7d91e69b9acaba7010abec9"
  end

  depends_on "nim" => :build
  depends_on "pkgconf" => :build

  depends_on "brotli"
  depends_on "libssh2"
  depends_on "openssl@4"

  uses_from_macos "curl"
  uses_from_macos "ncurses"

  deny_network_access!

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cha --version")

    (testpath/"index.html").write("<h1>Hello, Homebrew!</h1>")
    assert_equal "Hello, Homebrew!", shell_output("#{bin}/cha --dump #{testpath}/index.html").strip
  end
end
