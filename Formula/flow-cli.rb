class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/v0.46.2.tar.gz"
  sha256 "2d7cc3420bd49f78a9212716a9a3dbea64e3e265e780027c08d31aadaeb971b9"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "02a86dcf0e73ed3ec54ed64404170d11c8e3ded0a7e67a6a4be805dc969b07dd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "63595f43db83d584b6f0cadee1b84a8c6574e0f7ce1bffe8669b5559a90b223e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9bc6733f16cf92a9a0ec1afbacc48f8a364018868eef49cabc91b6b845f523b9"
    sha256 cellar: :any_skip_relocation, ventura:        "1647691e8c09547377bebe21ea496a621caadc68f40a7e578e56cd2e3b9250d4"
    sha256 cellar: :any_skip_relocation, monterey:       "65b5364a9754abbaf5d80b5484bb16dc779aff30a66b3161df5352e3e9dc516c"
    sha256 cellar: :any_skip_relocation, big_sur:        "ff2fb67e047258c6a7c38a8e1bbe89a0ed52faaf3c67a30cc77a1e12a5104990"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4230d17a16036db000c140327551249142902d6205e7048df844cd5891e92147"
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
