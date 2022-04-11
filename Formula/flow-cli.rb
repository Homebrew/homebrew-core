class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/v0.33.1.tar.gz"
  sha256 "c4ca8713cdb85b62d83005935d5dd60a22805f9ceb82ed5f2e6c43d9f382adf9"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9f01dee7c261f26650e014e75f49cc5b043992a1d442d4faf1a6866542ed5fcb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f6ebd269b30c7277e955c80dd7bef9684482359b189bb19f031a41fce854c7d0"
    sha256 cellar: :any_skip_relocation, monterey:       "0478229a225dcfc3a99fd108ae7d5f44944b3728921ff2afe8021b4399b80c9e"
    sha256 cellar: :any_skip_relocation, big_sur:        "d61150d5c6ad814524a22e399df1423771dac2e246acf63f5797db5035872972"
    sha256 cellar: :any_skip_relocation, catalina:       "b1a8d9ff1d5bddc61ff19715e944412dda15d69e198475e8905967b23bdbe54f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb64090b32d573e1d077edd1df915fc95d6b68c1b867ab42d6ebca194d1efb71"
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
