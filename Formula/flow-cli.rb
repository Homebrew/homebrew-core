class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/v0.41.2.tar.gz"
  sha256 "ce87add85fae322680dd8ca9464969d6d0e77003fa390b1859b6a20f27f16bf7"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "671ee4ee5d5ad293de5d25126ce75710a66131d77a172fd6a960c7a3d3dcfee2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3b3c50c1dcf84ba12ab56538631df062745e6e88d25a3d098154cccd6f2fd954"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d9e0f88478d3e495bc65ec004080c0dfc89017ff915b6b1c1abd1d3e3d599512"
    sha256 cellar: :any_skip_relocation, monterey:       "309acc21e2dcd779c4059b35cd4718d7ca31b19748eac709063348e7b776d3ce"
    sha256 cellar: :any_skip_relocation, big_sur:        "897619e8a7d7e1b0d0aa3cfce69aa2d2ac86e8335c7df975fbf7343b4c862a78"
    sha256 cellar: :any_skip_relocation, catalina:       "91b6cf88dde1240eb932d666d428ad12c29449e00e066abd0b6ea6c8380b41c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45a421c7a3bb0eeba63f33f40eddbe7e3136cfb67474b92b8b5aa600e5d141b8"
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
