class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/v0.41.3.tar.gz"
  sha256 "26d59c846376a19718b1e0afce2b905f33ccc293cc66a601e04597a9c6448adf"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2a0e6ffab0982082db99bb1e6e58092e50d6365bf6b97dbca9a03bf37e9195f8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f2d2a973d135a3e1b87fda44f8ad83e0c74786f70d19b6e021eb3ca51c520fc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e2e2a88e5c57fb99af2b845dbc544fd76b72f4f3947df78d4a680ef97e796b4c"
    sha256 cellar: :any_skip_relocation, ventura:        "1a3ddd9d351faf6c197ebf340466a36818aa9534c1365b17c9d6e241f115679e"
    sha256 cellar: :any_skip_relocation, monterey:       "2f8e32e891a78d82b300a4d2c78603b81274978caa619bbe15da8a37f2cfdb44"
    sha256 cellar: :any_skip_relocation, big_sur:        "830446c1ffa9b7c9f0d8097af1e5e08af4999371d9dc1eec602670e984e9e3fd"
    sha256 cellar: :any_skip_relocation, catalina:       "e3801691daed27a5a4a6bf386e0be4a038b7cb601f724d28722046714a68cd92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "209b6dec22fa6dc940dfdf4eb8a944e404787403f7e57ed8f91d3586390b811b"
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
