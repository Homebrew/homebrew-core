class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/refs/tags/v2.14.2.tar.gz"
  sha256 "cefaf65d436f98062eca230aa510541acc34383716e969d1d802b5a798d7cd7f"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d936da09e572376b72a944887732636bcbf17a4532f27195e2c7c0b1cb481108"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "764b7a0c0ff4ef5f7d7d4bdf3ae856802bf2cbea791da5574bea1ae3f29e9379"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "98ce5605d5ad1e59769a00cd2fb1d8800f62b61d44b6f274b2104596156a5324"
    sha256 cellar: :any_skip_relocation, sonoma:        "19a94b60bb3e9862cd3b653c13f691e54efdd2da24e9cf40614ed33e60bd0a34"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e12123476dba05887cb5896ab59f4552eeed5a3a28530ab3f9f961dce5c8fff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cff7c6f230d2fb312d9d8cc9f5e4b45b216529cb1d9be73049ad8632374a5079"
  end

  depends_on "go" => :build

  conflicts_with "flow", because: "both install `flow` binaries"

  def install
    system "make", "cmd/flow/flow", "VERSION=v#{version}"
    bin.install "cmd/flow/flow"

    generate_completions_from_executable(bin/"flow", shell_parameter_format: :cobra)
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
