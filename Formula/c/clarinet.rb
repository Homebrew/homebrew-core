class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://stackslabs.com/"
  url "https://github.com/stx-labs/clarinet/archive/refs/tags/v3.14.0.tar.gz"
  sha256 "2778d84fdaa60f234609f4491adac39ad76398fd93a6eb40986a725e9c345a08"
  license "GPL-3.0-only"
  head "https://github.com/stx-labs/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b1ed7805af61f643c469b01c4b911b6e0d5e1264ad3a38ced1bc08346be24539"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3330b1d5bb1242ec6972350842b131f0f451da7187e9dd0a7b03b4df912930d3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5b1af2b1da66cd0b99836ec1affa1c808c6fb25c4f5ce2e20b78a54b0b2258ec"
    sha256 cellar: :any_skip_relocation, sonoma:        "8264e7bc42e60e1973d864294a2b00635b801acc5e30446200b0b2b65c46763a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "52aef49598ad962a9add53d937bf31af9bca8a914a21b84d98b20cefa6344c70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "025ad565923dfce78ec5ec574d566fa9ce0b35171ac0274cfc433ac42f1de5d1"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "components/clarinet-cli")
  end

  test do
    pipe_output("#{bin}/clarinet new test-project", "n\n")
    assert_match "name = \"test-project\"", (testpath/"test-project/Clarinet.toml").read
    system bin/"clarinet", "check", "--manifest-path", "test-project/Clarinet.toml"
  end
end
