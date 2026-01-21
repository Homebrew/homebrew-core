class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/refs/tags/v2.13.4.tar.gz"
  sha256 "1bfbd4c42d4f5c00eea738bf93a1b6d1b90ad6a934af84b775f8aa1bd7381435"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b0d33f1fb94fe1a97b7e92377d16e6850d32e7628fdb062ae83ca3531a366a50"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4d5eca0db2771fad8d6be39728a4d9c7c434aa03b718ec520bad8ee3a780e469"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "522ed47a0879387b363bb1d9baa7a295fb343a7eccf8fe68dca2fa0badbbf95f"
    sha256 cellar: :any_skip_relocation, sonoma:        "ec694d033c8d81117b05ec834d0c98355453e61f4568a2f33daea9e91133ec85"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7fe3ed5446cdd2a191a66d0bd1db02013f3bfdb89312df294968abac85c65c45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dfe15af8246d1607424ba9ab6ea506ef0c447152db143f36ca52a23e88af15e2"
  end

  depends_on "go" => :build

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
