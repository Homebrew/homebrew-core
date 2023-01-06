class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/v0.43.2.tar.gz"
  sha256 "0fa0f9fc53324f3e18eba8b6922d467b9436ac366245ca40e149a646483cc97c"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "46bac808242660639d7d89c075dc1b1f471bba363cd513bbca9728073f66ae55"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2e3c93ed4405cac4ad8b618e045cee591d4c69eea5ab4a4c3bdb59a8c0813aa3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2f06222bce8b47896e581d6493af1d69cf1edcf099c6367dbd62d79a93f6919c"
    sha256 cellar: :any_skip_relocation, ventura:        "824bc82046487bd87bcf75394518175e207d8b7789905d5ea2ac1c864e871656"
    sha256 cellar: :any_skip_relocation, monterey:       "e1a997d2c272d7b17e6ef9fe2a39749304b5b58c8eb02492f98c71748e59e46c"
    sha256 cellar: :any_skip_relocation, big_sur:        "43d531f3f1d549647c55577e816cbaf5546a69af72a93b1b0d5c6003e293c7fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cae479db711e04f5d1c71847c20bc61ed77680950201a16da6e5140f2559c7d8"
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
