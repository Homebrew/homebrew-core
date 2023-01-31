class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/v0.45.1.tar.gz"
  sha256 "80d10f426bda69ce2a1e06282b60879e9118a643df40598cfb92458cc1b981f5"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a7f7d577efbc7aa5ef1fe1db57045e7436f24ad90732159b29e60f8f4ac9a4b4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7189a742eedc2f28648a5fd7d42f61ca328a6bb49e6b8f34c39e0c34c32344db"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "61d0e9389071200ab6c2bcddb24267543f26804b85e1ec5f345a7684afac9a4a"
    sha256 cellar: :any_skip_relocation, ventura:        "fe0b8124cb7ed0fb47c874f320fab18e9861c188aa0c949283eefa808b0a70fa"
    sha256 cellar: :any_skip_relocation, monterey:       "9c462d118c958b08cdc75f6882a0edf0d7d06df08c4228d108a4546426bb5abe"
    sha256 cellar: :any_skip_relocation, big_sur:        "663e5e0cc5e02c5724be70b16ed414c52c92bcea08347a6505c098d25f1d0db7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c4c97c65faf9c9e8a75aa50335031ef5062b34bf27d5d5fd4945b3cec83298f"
  end

  depends_on "go" => :build

  def install
    system "make", "cmd/flow/flow", "VERSION=v#{version}"
    bin.install "cmd/flow/flow"

    generate_completions_from_executable(bin/"flow", "completion", base_name: "flow")
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
