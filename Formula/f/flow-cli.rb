class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/v1.3.4.tar.gz"
  sha256 "5b231de344a9b8fbd562a9971871460ad809fa879a79a4d8ef438dbefed7f0c9"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4fbe13fe27d67535216deac0001535f505d415a2442eb551026a3183a8d3568a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0a28b01beff20a67b915fdf2471acee633515126ffc818b45f48ee8839680826"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4af5e577c2c86be3d1c8c31c197d45b26d7c7929edbc7b6deca238f7f533078b"
    sha256 cellar: :any_skip_relocation, ventura:        "62305a001e292afd8ad3c3fd992d59e166432742f6160889b73437874519479f"
    sha256 cellar: :any_skip_relocation, monterey:       "e32ec9339411cf2875527d12a7f32cb897ff65bd8fa5fd0acb17b19706f85c9a"
    sha256 cellar: :any_skip_relocation, big_sur:        "3e85de91369b488d028d2ec627eb8bd75b8f65282c780b76c68397e00fb614c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "91625ed91416a10d37132a93e3356be8b94b358e638e7985d28398852a736a0f"
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
