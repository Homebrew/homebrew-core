class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/v0.43.1.tar.gz"
  sha256 "1f103dbe714a9de4347510faf78fcbddb568c396e5057da819c6f4233be43bd1"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "16033880b85ffbc0feda8d1b2f86bd3566ef59adc7d17dd8ff78a8c2691ce185"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3858930143b8be2dea55cd2d09902921e74694dba58bd53d4a61a908d787fe3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a9137d6e2c1e607a2da7790e0e52b46e8c5617d76f29ec86f200d16639596414"
    sha256 cellar: :any_skip_relocation, ventura:        "4632e3f3ef7d03e7cc0a50fdefe60599e505d5b4d40df6dac8b77e13bd9aa920"
    sha256 cellar: :any_skip_relocation, monterey:       "cb3b9624b274b9df2772f415d2fe9711b5a5588ed253c47d953ca977ae902625"
    sha256 cellar: :any_skip_relocation, big_sur:        "c8963f252cceb91bd0091d1de50819311e82c71e720ebc34e77b75f71a942a96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4bfdad927375b04a1e8efe52836e7bd1636e214b3105423b77e6a6c34e6cb751"
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
