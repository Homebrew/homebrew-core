class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/refs/tags/v2.11.2.tar.gz"
  sha256 "a525c0bc5c7f7d138dab30e8b11d8db9f5260cc95ce22eaf8a00365bda5d3dce"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ee6d5338b09236071e500201f67bca8c00a769c2090126172224ec157c4c2ef5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a06bd8ecf885a80c70e352c83ba2490bc49b1b7a6ed5a39e8c183a046e45a466"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "69aaa266cb644bc3faaeb795e9375b0f56660e2a212d076ec97c30c0a95c7f48"
    sha256 cellar: :any_skip_relocation, sonoma:        "90542c5994196281e1907d30064e186efc5fbed1b05e576be187c8ba2d29f7e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "25f14ae849e3b92ebb43efa2c3ebe0473a4150a0af0d5c79558b42c1531b4411"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d51b669dfb5c2872b87b613d0c79d5f0d04a74c6122e6aab781266d7350ccdf5"
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
