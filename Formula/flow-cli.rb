class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/v0.18.0.tar.gz"
  sha256 "52f8865cdce2a7c456d332dd2100900cdcbd924f4f104a6a176362493b6780fa"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e5125a987757ca3814566b39b61049813ccc8832ec83b3afcdfab17923ab239f"
    sha256 cellar: :any_skip_relocation, big_sur:       "27b43fff23a2ce268a1fd3d67e2d314d52ab0869cd7cccc932cb69470dc5a92d"
    sha256 cellar: :any_skip_relocation, catalina:      "8795993de27fa7049245730cdb14297b787b95ee8212a64d3129f0b3619b3325"
    sha256 cellar: :any_skip_relocation, mojave:        "a2818b231e4606a7273e4b6861fd642a343e34965c57efc82382e9f04ee49a7e"
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
