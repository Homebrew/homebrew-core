class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/refs/tags/v2.2.16.tar.gz"
  sha256 "ef827f6a6c1b12ad5609d5aecc0af49c50b454d5fd85c022b1c960d3ff29af39"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91bcee800d7f33e6830dc5a3a61e881e9f0525570f8ef6cad89070c84f5c8793"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "28f0490d981659684f244cf192baab2ea8090edd50dc35aa7b07edd74cef16e4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f724315818a750b97a020cc3afeaabff78c0c1765916bcbf0592191e206f3eca"
    sha256 cellar: :any_skip_relocation, sonoma:        "9dff8b9b4fa238efb74b945e3e66a3f2a5b9bd9a568dfdd28da7791623be1692"
    sha256 cellar: :any_skip_relocation, ventura:       "f7d48a31bd6c2d0f72cc89c2d92a763ef5fb8e5aeeac20f98ffd2b7f71817a3a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d0627326472e429dfc6eddc4aee3313bcb88da0cc5621670a826d58c7291b879"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "946d0310a359e75555dfc1812ca20d69b02cd2b76ccd447312b3aa079288dca6"
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
