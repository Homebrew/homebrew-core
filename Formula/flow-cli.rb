class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/v0.17.0.tar.gz"
  sha256 "c362a84e4f6f7e52344f8d1d42141a7e9cc25f8489c4d0640d5ddd3d2932c19b"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "26c7c123f83961a75158d63da79adaf96213e84587ca0731d059fd33f2dbd2d7"
    sha256 cellar: :any_skip_relocation, big_sur:       "d1e94cf96a7d275a8030a36b706a944fc9d5381480a6408815e1818cc52ddc51"
    sha256 cellar: :any_skip_relocation, catalina:      "cb30122dd4e8d9f44216daa94daf6a151b41139468e1f73c54e211f19e351178"
    sha256 cellar: :any_skip_relocation, mojave:        "63c52b9842ef08534dad724b0a29232705b855489f21f5b6c13c5ebebbb64596"
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
