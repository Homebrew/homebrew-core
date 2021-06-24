class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/v0.25.0.tar.gz"
  sha256 "2182728a7e5e5b56f62d37b8eba03e60d9360a7f0285e7f0b1809aa38bc3b4d6"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7b40c87874b36f64415aee36f1fd92c7e9918a25667938a4df650aa5cb3b3bea"
    sha256 cellar: :any_skip_relocation, big_sur:       "97695dd1afa2de4a2584329866f2eff5a8b6c74cf1506e8d82ab7feaeb1c041c"
    sha256 cellar: :any_skip_relocation, catalina:      "721241cb81c98e618b4b9befc4651174472335251a57b12bff76b8af7c687658"
    sha256 cellar: :any_skip_relocation, mojave:        "32485788410a15f90b7361312b127606a14981d303fc969c9c0f62a836986eee"
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
