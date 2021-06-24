class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/v0.24.1.tar.gz"
  sha256 "5699b4343e71d4718ebe5ef9083969bf0e273aabb916f111b60dbd25ad694508"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "64f2cbf5b9acacd891263c1e342576e7112ca64f70abd314223b46e864fdee82"
    sha256 cellar: :any_skip_relocation, big_sur:       "e09258cfe9c579df196c5efc66c2010bf6d579d794a00a30281818d730b8138a"
    sha256 cellar: :any_skip_relocation, catalina:      "0443c5fa6ef93d583b4ed6a7e45ea27088c0d02833c2dd0b9d5b04ac2441096f"
    sha256 cellar: :any_skip_relocation, mojave:        "6df1475aac8f4f587acf5029d6beec7f654eb55bc54e147830819b57e1e8bd57"
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
