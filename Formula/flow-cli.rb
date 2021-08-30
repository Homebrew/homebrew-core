class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/v0.28.2.tar.gz"
  sha256 "9b011bb78297e7d9e98df884dfd132b1f1e9f35871105a86d5b666c1a2d28089"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "dff663444b06758897036c0c1f1130c95ead7001406ee65e6e10ea63edbe70d5"
    sha256 cellar: :any_skip_relocation, big_sur:       "37372844bf21bc507fcece25a0765e606a7a65ec9305bb189d2a58378d908043"
    sha256 cellar: :any_skip_relocation, catalina:      "d89ff0d5a240554afa5c93d7b94f3179be2dc302d72f719f45d064acbc657232"
    sha256 cellar: :any_skip_relocation, mojave:        "873699d0c2cfe18dbc8de97df68e5c4b29f594f9da4480d23cedcd29427ee715"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1ecffd22f64f4d29ec7430f740c2c5a253db005920f5bd03cfca33459ff4e90"
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
