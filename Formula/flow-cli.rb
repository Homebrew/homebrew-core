class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/v0.36.2.tar.gz"
  sha256 "19eaff46eda642f2551fe524b6591c0ec5630006a817ca3810d09baae9263371"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "036d8b2e3e2c11dbdb2491edc731812a69d9a7761cca74c737909a938fe1cb6b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6698fc06dfc3d082d97fdc5eba6a1588fa25ab5aaf32cdd3d59e5ec53946c05f"
    sha256 cellar: :any_skip_relocation, monterey:       "8f665f32c6420905bd24cb1a060677259cc7b07242532270a3c901b1419404cd"
    sha256 cellar: :any_skip_relocation, big_sur:        "31eb6aa7b0bfb6b055073db17e2b19161c9eaa27d6604ec36cd8b5b0258cbf11"
    sha256 cellar: :any_skip_relocation, catalina:       "53641e8d83caa04c003b9eaebffcc3fd1c3105104ecbd7b649204a4a8a9a8ca7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "839c9fb33343cdc4c68f2f474157ec54ebb31d84051100ce32b8f9701cdcc398"
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
