class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/v1.4.4.tar.gz"
  sha256 "d5c5626c6d40c8046b60c1bd50b0f3dd3f8f54a450ca6f8a5105bd62231d21fc"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "31776e4d0c47da60d6315ed9225eafce5e0857a25f4307754a4bf23d73cf521b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c2336bb4bdf03dd1e952ae56996770e2c4f8611971dca91c8f755a9d5d2da96a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c02c191642e1c630e5cf2a703e75e321f6f8bc82af177b7e485ecc5e29008dd4"
    sha256 cellar: :any_skip_relocation, ventura:        "3b1da961060e1d34a69a07f2893b8b8b73035d0a3dd0f82d6028a791dc6e1ef5"
    sha256 cellar: :any_skip_relocation, monterey:       "ddec5aa57775cb09a064075c0b84058374a0ac2756af68b493d8eda8bf0387d4"
    sha256 cellar: :any_skip_relocation, big_sur:        "e58f370d1508147038f84b42ae933cd82a926af84f9fcd4cc095f0df204618e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "548fe719d4e660d25e33aa86a923ef124c2ae451884974ee2a64bfbe52d82715"
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
