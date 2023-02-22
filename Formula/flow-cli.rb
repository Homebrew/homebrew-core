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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "76370b6b8b275fcaac8c7a43db48c3b6d304a4f7b133cff36ae5ec02e541221a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ba91ddfdd68f7cc4c8e9899a8fd1eb39d63a58850382d650e290373201a2cf8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "414510cc6fbb2ded8108b9374c0815c2542aef8aa5ed7b694ac8e0c31dc055ba"
    sha256 cellar: :any_skip_relocation, ventura:        "2fcb7b35f8e8e0866eebf63cbe024a5881e7f717d42faa74bf6c57c3f55251a9"
    sha256 cellar: :any_skip_relocation, monterey:       "254cc2085cbdcdf5983ba5028229c610278a006469c6f1c69562a51f7f4437bd"
    sha256 cellar: :any_skip_relocation, big_sur:        "52bb0c047f9ae5afd2537dd0dcc76bfb42c38bda06d0b2110fa4210482404803"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b79575ffc2fb329c8fc7ba12f819ce4afcc64656a4ab4aac55dfd9a11236307"
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
