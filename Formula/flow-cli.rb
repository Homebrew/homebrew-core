class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/v0.19.0.tar.gz"
  sha256 "2ac11f914f9bd7363a72ea16fe1311001c488398151bd6094c08b7d0da510bd8"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "640730183411e755ed6bc1e402ce48be6a3286ec2b6376c7ba5574573b21334f"
    sha256 cellar: :any_skip_relocation, big_sur:       "e849fd2ea976df73999d503e4f7824e13eb41ef4e1b4c29948a52286265a54bf"
    sha256 cellar: :any_skip_relocation, catalina:      "b525e416ddce879d95776311f44f4b4ca1c9a5f74ae154266c42976560b7bc0f"
    sha256 cellar: :any_skip_relocation, mojave:        "dd28a86697f3e90a96541a18454aeaa155dcedd16b5044d8a38fd3c20d6efd70"
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
