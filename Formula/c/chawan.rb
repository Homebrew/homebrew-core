class Chawan < Formula
  desc "TUI web browser with CSS, inline image and JavaScript support"
  homepage "https://sr.ht/~bptato/chawan/"
  url "https://git.sr.ht/~bptato/chawan/archive/v0.2.1.tar.gz"
  sha256 "809f15bc283a27feef03a465f5cccf9247c6fcd2e57dca54aa0f1fb0e1bcf7b9"
  license "Unlicense"
  head "https://git.sr.ht/~bptato/chawan", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3f0217092e5152fefd0253c4e9863c87ed8a623efac564873cf2419066448d24"
    sha256 cellar: :any,                 arm64_sonoma:  "d1d3a3a660caf20421ee32fd74ee9124863ba3202b49c7f2f12da4e34887a8b1"
    sha256 cellar: :any,                 arm64_ventura: "b6fb19cc483786b7481b8909bec324d076fddd1ec817a7b47f1ae27f7cca130a"
    sha256 cellar: :any,                 sonoma:        "2f7eeac0d054ee3a933a7fcddc1bb600ec6b82ffe8461b6ce38e4233391010c1"
    sha256 cellar: :any,                 ventura:       "48160700c2e9332ce964c7b40f2c7088b4d731c4c19c20353615e6089beff652"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eee9af4aa631c07dbde9e57f086cae993639a780cd0b0ba2a21e828bac40a894"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b688409bd2b741192d49fdb4d6ae7fee5b6bc2889d8bb60897f476f45c4c35fb"
  end

  depends_on "nim" => :build
  depends_on "pkgconf" => :build

  depends_on "brotli"
  depends_on "libssh2"
  depends_on "openssl@3"

  uses_from_macos "curl"
  uses_from_macos "ncurses"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cha --version")
    assert_match "Example Domain", shell_output("#{bin}/cha --dump https://example.com")
  end
end
