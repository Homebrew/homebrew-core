class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/v0.32.3.tar.gz"
  sha256 "7097e5381c4807b7ba4368ba398c995de6ae5e994abf178ffb22836bab42e2e9"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc989c838a5075171693fe5e56dbc8468bdd4dc850c4b7918919b6ad97c451ab"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2b3a06100037e80aaafc4103081ccdc749db24bc2f83fa66779a8e894d210c87"
    sha256 cellar: :any_skip_relocation, monterey:       "884f246eb1a8568adba7656dbe9e493193ead1a3a31a15942c86ac9da6d1701a"
    sha256 cellar: :any_skip_relocation, big_sur:        "1bb58c4cc25416ce072610d789907024268ef3f4330ece6d4e2d5599f806ecf3"
    sha256 cellar: :any_skip_relocation, catalina:       "39cb54ca6f606f87928a69f91d24a395c714a3b4d6c53412e9de3928956119e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb12b1b81487246211ce9edbe6f1e175d30f605f8772977a9bbfe8f756b3bc9f"
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
