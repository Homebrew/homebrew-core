class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/v0.12.3.tar.gz"
  sha256 "e19fe8dc70762f1ea2c56ae9f1c0bc2ed2d7b38efc2d87eddfca3d92cd0cc37c"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "404371fc786604d0cbaca2bd92278a20ee9cc6ec76738fb43da95968307bf505" => :big_sur
    sha256 "57896f09498936c80f7757cf5b2f4d329ce1c0a01b0e01edae3f2ccb1cb3c398" => :catalina
    sha256 "35d728f50b5c7428d4ff40b20ecad52fcd13064fc24d135b857db560e68d1cf2" => :mojave
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
