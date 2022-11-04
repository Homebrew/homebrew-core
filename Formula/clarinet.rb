class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://github.com/hirosystems/clarinet"
  # pull from git tag to get submodules
  url "https://github.com/hirosystems/clarinet.git",
      tag:      "v1.0.5",
      revision: "4cb675b911d3cbfdbb0d3efd879d943a3adac358"
  license "GPL-3.0-only"
  head "https://github.com/hirosystems/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "50a9c0fdecaba5f263f52a5bfb3189b84f3b9e963ded72f026fb90a139d1c6fa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aae62470356a76b342565fa12f455b7e64dfabe633f63bacc79ac71708b017cc"
    sha256 cellar: :any_skip_relocation, monterey:       "6d9df9c0dc5eba7cb222593390ab0646cc21d4435474eb209f692225f59698af"
    sha256 cellar: :any_skip_relocation, big_sur:        "1fb66e5ba693d7390cfca517bca3823c88d7cae59b72663e71dcaadd310f5f4c"
    sha256 cellar: :any_skip_relocation, catalina:       "409e951429eb57c85f784a6f3e70abaf97d60fbfc02cfb136d8bb7191b742555"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4135678f61090475e2abc3e37456f8ffe0451c6f7f9fcaa6b2c061d7b483dfab"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "clarinet-install", "--root", prefix.to_s
  end

  test do
    pipe_output("#{bin}/clarinet new test-project", "n\n")
    assert_match "name = \"test-project\"", (testpath/"test-project/Clarinet.toml").read
    system bin/"clarinet", "check", "--manifest-path", "test-project/Clarinet.toml"
  end
end
