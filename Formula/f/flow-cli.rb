class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/refs/tags/v2.2.8.tar.gz"
  sha256 "2e6dba770478a9a68dfaee11d754831267bc3131bf285c9f0e45d5c25286f867"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4191943630550e557d61b6e06e0f2f0c9a2e94cd7c0910ba795d836e9f51b5ce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ce8b7efc8da2a7a822341223cb93a3313886d50944e39efe26cb88166da2f701"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "70b6b03fd1ca4b0430156cd076f32a69d12db9fa0bc7808c278e7bbef97e0d78"
    sha256 cellar: :any_skip_relocation, sonoma:        "223244851d090bf788031236410045644f312b12f83fe1bbf0fc596482fcc769"
    sha256 cellar: :any_skip_relocation, ventura:       "ca65771408d5f7f9a162f736c43d7b52dff8601097eda08664dc3ccf45b5b16e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3946ee6f1f8e49edeb507f566a3a48bf85dd133869f2a147465251aff0cbc448"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51b449f12388932b54cfb288db3cc9731fab76ed1878e097de680b437492d460"
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
