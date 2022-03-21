class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/v0.32.1.tar.gz"
  sha256 "7ae284d7fd954879a598d60afe925020f34c0b522f62f8d8bf8d60ab2923e628"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0d10c6181a63a4c4161ea2498f7b728b6c91120a5af3fc609266c72d398c0cf6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a2a7a1461704bb9c6824efeb12bb849dc80d908ca7b22aad582249384a78ca04"
    sha256 cellar: :any_skip_relocation, monterey:       "0726f1a90d760348b6d43bd3456e267a23f29b9a3a328131f406518377322b90"
    sha256 cellar: :any_skip_relocation, big_sur:        "e7d38f3980e652c78187f55834d3a18409a175a7dd5a9c91e8f775f222b7966c"
    sha256 cellar: :any_skip_relocation, catalina:       "41795064f875e817fa91bee44e449f2687e7bee72a4e5ec72f83c27bac4336c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5925913515b6bb80e8a3e598b964b94d169667c909b55938795007b6c277c209"
  end

  depends_on "go" => :build

  def install
    system "make", "cmd/flow/flow", "VERSION=v#{version}"
    bin.install "cmd/flow/flow"
  end

  test do
    (testpath/"hello.cdc").write <<~EOS
      pub fun main() {
        log("Hello, world!")
      }
    EOS
    system "#{bin}/flow", "cadence", "hello.cdc"
  end
end
