class Chawan < Formula
  desc "TUI web browser with CSS, inline image and JavaScript support"
  homepage "https://sr.ht/~bptato/chawan/"
  url "https://git.sr.ht/~bptato/chawan/archive/v0.3.3.tar.gz"
  sha256 "3ebcd653e90684ba2e871968b19af77ced082f224cd084e70998db7e1512d1c5"
  license "Unlicense"
  head "https://git.sr.ht/~bptato/chawan", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "90360e8b7da49b4271a5b0e6cfc783fa0c74828cc9f13192642f2814b173e187"
    sha256 cellar: :any,                 arm64_sequoia: "badfd78d8b446524beafd88668ff9fd5cdfffdd378f693a49635505c76f878d0"
    sha256 cellar: :any,                 arm64_sonoma:  "42718595d114ce89567fcafd5460fa929fe432bbab899ce33fcbd9fab8917719"
    sha256 cellar: :any,                 sonoma:        "d74463206c96e4fed9e95878d3cde9a748a181c40b526a608a747218cbb0e129"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0034327f3c9aa289cb2bcb96df0aea048f5b32ffc3e4c87ce5cbffdda2dffd89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f746919e0b1b5957d148061e859fc8267fd700b0c989b8d719ac23f20ca7b26f"
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
