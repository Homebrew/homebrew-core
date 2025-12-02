class Killswitch < Formula
  desc "VPN kill switch for macOS"
  homepage "https://vpn-kill-switch.com"
  url "https://github.com/vpn-kill-switch/killswitch/archive/refs/tags/v0.7.3.tar.gz"
  sha256 "dbc1fc04e9945049e0cad3aa18740394cac9d93a0aacca00d45c82ec891346f1"
  license "BSD-3-Clause"
  head "https://github.com/vpn-kill-switch/killswitch.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "65e4786320fdae32571af5ef0991a647ef7b329c7436ee7839ed0c18a138762c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "774a26f0fc7ef071f5b5ff472ac6dba6f0ef5e117096f2de5bd558f1398ac464"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "94166ec9298fa9ecabd8f1f736c7a1105aba2ee0cc3188d290206c3192977846"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "db44f0faa40d85df1ced75869c6fa1246cfb8b9b46ca509f70a18feb8c5e0bdc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9dffd3626a47003a56db382b174ccfb1d02457ec762fc7d8d16df999fcb71a8"
    sha256 cellar: :any_skip_relocation, sonoma:         "00e16e045b4dd9f5d1f5013c9194b4d94954289a8d54a581165fe8dcf9a8924c"
    sha256 cellar: :any_skip_relocation, ventura:        "70b9b5e586bcf54547835f5a9f56f5230080846446768d5fe2611c69b7c7eabb"
    sha256 cellar: :any_skip_relocation, monterey:       "d942fff71b6a5c2178f10dd222bb6fb5e52d2bd01d537f85e3b4ea1dff53cdab"
  end

  depends_on "go" => :build
  depends_on :macos

  def install
    system "go", "build", "-mod=readonly", *std_go_args(ldflags: "-s -w -X main.version=#{version}"),
           "cmd/killswitch/main.go"
  end

  test do
    assert_match "No VPN interface found", shell_output("#{bin}/killswitch 2>&1", 1)
  end
end
