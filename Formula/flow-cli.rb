class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/v0.20.2.tar.gz"
  sha256 "995d6d22e5e6f12a9fda99864f4f49f9383dc4bde72109eda1e34f494cadf668"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "eefcb573d843f647ff2cbe05379dde21954517c475cdbb0201dfbbd834c6be51"
    sha256 cellar: :any_skip_relocation, big_sur:       "72d181c3a3a85d2949b0104c3f7e37ed1c100203c3a2fd7f906047d9661edfd4"
    sha256 cellar: :any_skip_relocation, catalina:      "eaa3dbbcf691667de8825609c46ab6586776a95b3748a4b54a3b815142a82a53"
    sha256 cellar: :any_skip_relocation, mojave:        "e0ec89417b469414e29e89e93e1203513dc90d45da789fc285c6c819808f4f06"
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
