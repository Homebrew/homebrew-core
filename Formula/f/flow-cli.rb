class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/refs/tags/v2.15.3.tar.gz"
  sha256 "0f456508d8e6b594bb40c13b01f2e9572dfe87cae5fe993278a69c1cd2115a45"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "98bbc45ada0ad60e69a56a1c25df322f2a856333eecf3e6885026c3b1acd549f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e8d220c935ca28644aa2a612e6a36927c41e6d2832b4e7aa4f03a1599705f026"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7de05586cbb2ff653a8cfdf9ad871dbe54a167d4be2d4a052308c105315dda9f"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f663fedecab46335559630a231cc65f68efaca18f80ee8f9ce9ba2a4cd0da91"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d1b337baa13f0d2b513c8a33c36bed1b043dd711a4372e6dd696b4647cbb0cab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a807d8a6c3e71fc216091da252603261fc0851b97c610866ec0af45901a9272"
  end

  depends_on "go@1.25" => :build

  conflicts_with "flow", because: "both install `flow` binaries"

  def install
    system "make", "cmd/flow/flow", "VERSION=v#{version}"
    bin.install "cmd/flow/flow"

    generate_completions_from_executable(bin/"flow", shell_parameter_format: :cobra)
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
