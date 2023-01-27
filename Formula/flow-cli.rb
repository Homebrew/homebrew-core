class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/v0.45.0.tar.gz"
  sha256 "4c75e93edfff25c685d10a4bcd9d09f9599ee81994949c68d9ae6ffdb420aaed"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "96a523cb773242fba0773c4ce33296055bd5aedc783069c58007beb37667c8b8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4df1b8bcd623609441daaa7722af1bbc1295ab72b764ea73d9f5558e4aac7dc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9945d1279f1d1c8fc9775485e1cab5a6826870739bf986b2fe7aafa77cb91501"
    sha256 cellar: :any_skip_relocation, ventura:        "d5bc1f6e10f134cd8eb996f94a5ed5f89f0471579e2c6e316e1414dc6e671864"
    sha256 cellar: :any_skip_relocation, monterey:       "4be970c41b4128e59cb9eb82a925912df515ecf1903a5e3e9a321c86df386c9d"
    sha256 cellar: :any_skip_relocation, big_sur:        "a539d7ed66f4fd3367323eb2cea5f141384f7856b66f055ed5fd902f74f2c4f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33f8b14fc7b379712461c2043bcd4723bab2f7ddf33ebc9271041dfc8f60ffd3"
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
