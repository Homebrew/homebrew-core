class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/v0.24.0.tar.gz"
  sha256 "ad9f8f129d4bfc4dfe43c8f93da38b170f2f78d0f6ed6cf4d722dc8120cadee2"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3f9a7888d34c8a770981a505c882258fb2fa072a211044375ffc648d791558c8"
    sha256 cellar: :any_skip_relocation, big_sur:       "99658a10be77654ee65f1232a98c82387c411c8d9728203371986fdd4ab6e8f0"
    sha256 cellar: :any_skip_relocation, catalina:      "bccfbdd149ffb185b1ab40b6d320e4bc79738e29a8bfa0993c9d237b4fb298ca"
    sha256 cellar: :any_skip_relocation, mojave:        "abe335da3e902fa6c24eb8c3054248cd2ed87773937fa14754f58fdfbcec1c4c"
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
