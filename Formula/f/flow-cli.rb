class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/refs/tags/v1.15.0.tar.gz"
  sha256 "fb951adf87b29bc7b128a2952a2cef9f342d082c598b327f86d03a4e62a5545a"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "68342c15e1e1ea61d9ffa615580c81056c3bf39cea365f087d5c48a451d23419"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d4b774699fbf4afcbcba287fd890e921000cfe959a346edd6c5224a48f41398e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "76cbf49acdff63e4c6d9c1c153abe1eab71786530e8414ab7c81c8d24d4cd3f9"
    sha256 cellar: :any_skip_relocation, sonoma:         "9f5a9ff6de9003f62ff0cc9942b584ec751e22efbbaf66ebe631364a4c7a1029"
    sha256 cellar: :any_skip_relocation, ventura:        "18a15395676e8f5ec4f0b6e93806a30be0ce11f399bfc8bba08700d351a5bf9e"
    sha256 cellar: :any_skip_relocation, monterey:       "e6b5271c00f3f206e9c1505d212844eeed424cda98c11018e88753e503ce42b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6de83b36ca636eb1e210f5bdde363cacd6846a31ab7d1129ac6abc32ef4b12b1"
  end

  depends_on "go" => :build

  def install
    system "make", "cmd/flow/flow", "VERSION=v#{version}"
    bin.install "cmd/flow/flow"

    generate_completions_from_executable(bin/"flow", "completion", base_name: "flow")
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
