class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/v0.12.2.tar.gz"
  sha256 "ac4d04567b946faef602962ccec13fa711034d0bb7d5f01cb368fb083cc45164"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3175e54be30ffde72756f133e3a3c57e041fce1da732c7cceb029a8605222165" => :big_sur
    sha256 "d2e8eb6e2341f1c4f4539ebd97fbdd5274ade916408a90368977b2161cfe8818" => :catalina
    sha256 "ff160b6e738b4035978dceeea7e66cf9e18b1cdad87b847f3c212897461c31b2" => :mojave
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
