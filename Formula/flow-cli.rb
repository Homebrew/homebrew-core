class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/v0.28.0.tar.gz"
  sha256 "73568437729df7b6e8bf19326356ba0f1e592164aab2ddcaa90fd17b33ebae64"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a16cfbb499aaf9acbea7cf72340522716079c5e72ca97aa0c05fa0d1c1d5c257"
    sha256 cellar: :any_skip_relocation, big_sur:       "db122d17ba6b8d43cff7f5b60982766a21cc00949ce04fab5823935d3d7bebca"
    sha256 cellar: :any_skip_relocation, catalina:      "c1024316df6915f50e31d730aa87876dd3fbda4ca0d155148825a9ea78fec63a"
    sha256 cellar: :any_skip_relocation, mojave:        "d6f65c71a3274343429482240fba282c9d6def5ec268b211d9f0f6efa97c992c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9869a72653bc0f4317a2b1524ff1961136e54787bbc13f82d9fa96017eb54fb8"
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
