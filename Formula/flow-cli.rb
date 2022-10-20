class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/v0.41.1.tar.gz"
  sha256 "6cf7ac66a99676931a8d763dadae12cd24f801053b4c11bb7781d163b5419cc2"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "90580ea693397e550cc5d71d5b5e5ecac9fcf268935544ce54631e2dc8c4326c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6151b693127fcbe03119b20dc99600e4bd8c3b2faae62b40053a85e4825bc699"
    sha256 cellar: :any_skip_relocation, monterey:       "c4033aa47e9e9828a46845786b7b838f91f1bab10e6bada5ea1e8df7a8b75a79"
    sha256 cellar: :any_skip_relocation, big_sur:        "c3830f014820c070903a56fbd9392a7fdf972728fa65224546829051e76d88bb"
    sha256 cellar: :any_skip_relocation, catalina:       "025bb42f384fbdfe147a555893a22d7e6598db43560dc1453e233cb2d585cc8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1840adf4c5728b76c50ea9d7f428b308895c2df29a92b4609d1291595a98086e"
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
