class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/v0.37.0.tar.gz"
  sha256 "2132f43ff7351425a091199543d7556904f3e79652a9274300646c2fe40ffd05"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25ff664bdf88598a3ad251d39dcb9eeb4b6dae74ce86b8bb33ec2bc122d43922"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e005128bf7b008d4d2f310d94db466cbddfd28c62209768c95523b1739ea5b16"
    sha256 cellar: :any_skip_relocation, monterey:       "8ca06e35c836fd49332d5928b7da2230783929ae89f71d4604098190e0479776"
    sha256 cellar: :any_skip_relocation, big_sur:        "09dac2cb22df8f38467b83410916c6d6cf3c697afdf7652277c51f541ebae3fb"
    sha256 cellar: :any_skip_relocation, catalina:       "acb4a5eba4833b20c385b1ee831f9018a1f39f1345116fa7fb59d64d6ac4691d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "668564c97b8b310b78b409a24ba364a0913e307afd0581a6454819f4adaf9c75"
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
