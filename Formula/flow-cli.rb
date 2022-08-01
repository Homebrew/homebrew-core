class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/v0.38.0.tar.gz"
  sha256 "1c4b4e56e8730f940a8655e6ba2e184e9c88a49d410d3a3abda8dd64fb34b312"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "58c718bf9c23daadfd8a891601758fb2454ff1ee5d1b4a7367b44b4c22fd5806"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2d76e78029ee5fb5e1f29aa947c5296a3dfdde4a6a87c8002b3621427f8fe89d"
    sha256 cellar: :any_skip_relocation, monterey:       "9610fe916ee5da14ae6787c114d10e30ee36526e50ce294014241ebe971dbd14"
    sha256 cellar: :any_skip_relocation, big_sur:        "1528f7308c43812f4f1713a2d834304b5ebc2d419332a151248549f5832a74fd"
    sha256 cellar: :any_skip_relocation, catalina:       "528e04c723dbeee15390d159ec529d3319508d23cc64ffb7041179112c7453d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b36c809acf8a8b9a7de753801eb0f6906d88a0957ebbbaf662b2546721f25571"
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
