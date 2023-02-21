class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/v0.46.1.tar.gz"
  sha256 "e99be0ada83a96b07cefc1fb48a3217771ff7a83396ca17ea6f4cef2df23fa31"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0e82a5e8eb3a734d20ce8fa7749f5efdc239bc9505f01fcb9e7f5992795627a4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a34d122c1d0617ebf91b15ebf9c674613c4dd78553f768e59fd9e54b0f8896e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1c28560ee211fdddb6c87c8b2dcb4139f980b080c708cee2f8816ff93dee275a"
    sha256 cellar: :any_skip_relocation, ventura:        "254cedd94cf592628537ed0334c9d06a2b9a54fd68bf4221d125bb8fe352f408"
    sha256 cellar: :any_skip_relocation, monterey:       "b8009b07e653a0dc09ac5d50ef6362a0dbf459309885cd4b5b96136a9a2beb11"
    sha256 cellar: :any_skip_relocation, big_sur:        "14836ea7dddad3b4c015177165d243beae4de46a920dd74e61f0f8a3d01322c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "976d5ab112749aeba4c2a673952171dff01925c6bb7fdd27a635f4d15e3a7288"
  end

  depends_on "go" => :build

  def install
    system "make", "cmd/flow/flow", "VERSION=v#{version}"
    bin.install "cmd/flow/flow"

    generate_completions_from_executable(bin/"flow", "completion", base_name: "flow")
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
