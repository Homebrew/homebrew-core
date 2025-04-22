class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/refs/tags/v2.2.10.tar.gz"
  sha256 "b4a02ecc9dfb066a602f6888788456f6e31e83b81506da8c85c0d5850a681501"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "140db3f347996a7eb8de1abe43a36a887a3a11f6ca73a87370af40b7c898add4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6f4340415ba991fb87dde91eaed2ca3f0922a9044c6397b5280391418451580d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2ededbb3176e3d023d25cb3468ed540a5caeae71bef040a2d3a0898900af3b93"
    sha256 cellar: :any_skip_relocation, sonoma:        "b4cc580a98f9e65517fb0c4614a77aa4938b93cc144996a16403003645c91e77"
    sha256 cellar: :any_skip_relocation, ventura:       "a978151dd5aec878237138ad92beb302c080dd83062daee913de7763b4ab682a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "61a5ebbf61b7846efc4d1b2bd6270c78faabdc2bdeb0532d700a54c9dc49590d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "963894b5c1525c71f9d221bf4b66ade128e715926e29ef08b34d6e2d1d8bb53c"
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
