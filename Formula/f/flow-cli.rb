class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/refs/tags/v2.2.11.tar.gz"
  sha256 "9c25494147ae42f3d93ebc61792424f00fbf2f3227f89ff53a0165f3484eb76c"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b51c22cf8a46aa6140effc3bea9c11144683387b2835019fa08530b8237b5a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f6acdd57a5c2bdc355eba3073b0fc69ee6590c95346094d69694898bd8f02017"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "52bf8349a7519f1d986d9e8b1a335ae616df85f5bd4d43f53ac656fb0699969c"
    sha256 cellar: :any_skip_relocation, sonoma:        "e08b263a9e767f3d13aab29dbd2dae181c4e966d7fd6c571a40b4d67aca08a67"
    sha256 cellar: :any_skip_relocation, ventura:       "f855d303f03e17e80f98327b29795495eafe19cb73ac72890086f4e3b92eed03"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7390c0b7fb16fd7e66e57357e169feed3fa916a86e1af8f8b62a718405c5de79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2cf98fd11bf96dca4b5f4f966c08d0fa93cc06e1422e166a2b77e6a673b08d9e"
  end

  depends_on "go@1.23" => :build # crashes with go 1.24, see https://github.com/onflow/flow-cli/issues/1902

  conflicts_with "flow", because: "both install `flow` binaries"

  def install
    system "make", "cmd/flow/flow", "VERSION=v#{version}"
    bin.install "cmd/flow/flow"

    generate_completions_from_executable(bin/"flow", "completion")
  end

  test do
    (testpath/"hello.cdc").write <<~EOS
      access(all) fun main() {
        log("Hello, world!")
      }
    EOS

    system bin/"flow", "cadence", "hello.cdc"
  end
end
