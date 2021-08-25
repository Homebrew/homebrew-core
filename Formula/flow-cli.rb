class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/v0.28.0.tar.gz"
  sha256 "73568437729df7b6e8bf19326356ba0f1e592164aab2ddcaa90fd17b33ebae64"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3003ea3b5b1f97477da57cec6e06829e946932ecc25f49ccd8680a24efcb50d8"
    sha256 cellar: :any_skip_relocation, big_sur:       "5a7c51f4ad7f9973d276b90b16291cf7358731b18664670bb2f0a2d8400cdddd"
    sha256 cellar: :any_skip_relocation, catalina:      "712bd6370220331d524f96f7b117108fd098fee916acbe6aa015b8e9e0fd30e2"
    sha256 cellar: :any_skip_relocation, mojave:        "584940cc8a8c956ea3b8b52718fa70c49cedb689fe58adf0258332a4a35fe27b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b221fc9f0cad54cc7821d76175e870e7aca4be16fd84b7c85c7a9861997dafc9"
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
