class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/refs/tags/v2.7.3.tar.gz"
  sha256 "2c9ce237bb35c4ade0f0208892b8235fcdee3a72cded883fed69c0cad3afb5c0"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9adc25ac1622c557a0b192f203dbb4e3c747e4260bf8999c2b09eab6fbf5aea9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5501f5ce13a5fd02266435543be88ee0e93749991a403dc1b36488fa4e66feb4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5291b6f38f147a7f570aa30009c5fd88ce6999dd85c2ac9de73d88fcf996e8cd"
    sha256 cellar: :any_skip_relocation, sonoma:        "f0a4b3e3a6ea8b6a30d0f6ae4cbe51896a4f503599f690d456ba7a531ca76b82"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2fd103cdba18af9cd07e08ca68865e389c825f73c381b6793fe40422c0e5b251"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ffd23864a3989d2e4bc75ba5dface56720381d688c8d08dabc1e171d36991283"
  end

  depends_on "go" => :build

  conflicts_with "flow", because: "both install `flow` binaries"

  def install
    system "make", "cmd/flow/flow", "VERSION=v#{version}"
    bin.install "cmd/flow/flow"

    generate_completions_from_executable(bin/"flow", "completion")
  end

  test do
    (testpath/"hello.cdc").write <<~EOS
      access(all) fun main() {
        log("Hello, world!")
      }
    EOS

    system bin/"flow", "cadence", "hello.cdc"
  end
end
