class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/refs/tags/v2.6.1.tar.gz"
  sha256 "125dc2347d6f2c9500b559100199fb7318c6d18ec97cb3c6fde0bc481549fc32"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1228159df9bf82be6d46997a679d1a8d724cde1b74736ec6cbf0f5a045189f2e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c8995868bca33d909bfd3f8d5b8e7740abbcbf450a87731551b699384153ba8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c3e51773a9b13bf750ace1754e7a3191c0c62975ba41a754aa92d427f6335d4"
    sha256 cellar: :any_skip_relocation, sonoma:        "2643473f4335059b01597fe93083e37db98e0ef2e4f44aabeb44cb06be8c3386"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e99ae53d1f028277f57420abc4cb7410d46dbead12e2dded1da5f6914be252e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "098aab2e919adcb7f17c07943b3e4b8074d9c8da2935523361c0bd70164a2127"
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
