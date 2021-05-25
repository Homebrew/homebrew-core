class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/v0.21.0.tar.gz"
  sha256 "17f52272bafc48a9aeaa1d5043e64c71f4bf16744ec5ffd98031ea5ff512f09b"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d152462f381af431db65c05a024b5bfcd028bbdea860d38df736a1f6a0306c23"
    sha256 cellar: :any_skip_relocation, big_sur:       "bbce316b15c3e134e94d02fd7627f7f50afa70a5c806b26a4d78fdf81f707953"
    sha256 cellar: :any_skip_relocation, catalina:      "517195f1c320fad48aa79fb47c50b4196e3edcfc987a4d7df139bd43e714c88e"
    sha256 cellar: :any_skip_relocation, mojave:        "51544bad5bcbd383e4589e6c5b663c96a6ad375e639a7dbab294c0e7e1922150"
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
