class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/refs/tags/v2.0.8.tar.gz"
  sha256 "b4fbc47575fc8b54d99ecfcba3b1748d6dd415eee53818671dedd52f89ce9df1"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "384b71591bd565a54969fa99b0b8a672a80b57790341ff2756de40bbede0b41c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "219ccde216a056c9f92a7b09b265aad07a59a6dc8479f9ba1b964b5174dc9dbd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f3440448c65a457e4eef91d307b55337ffad989fa32dad919338dcc7e27dad23"
    sha256 cellar: :any_skip_relocation, sonoma:        "a477e9da66c12a82c5502a9c14537129e070cfcb128ee6d5f4701b2ecfe9a74d"
    sha256 cellar: :any_skip_relocation, ventura:       "10cc9f6872cbe9c96da3771233b618077bc344b5c2099f8cc14c22edb404521a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6568263eeff7df915be1ce77f7f850d62fe56591b4266f78566bd188422a5dda"
  end

  depends_on "go" => :build

  conflicts_with "flow", because: "both install `flow` binaries"

  def install
    system "make", "cmd/flow/flow", "VERSION=v#{version}"
    bin.install "cmd/flow/flow"

    generate_completions_from_executable(bin/"flow", "completion", base_name: "flow")
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
