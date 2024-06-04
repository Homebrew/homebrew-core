class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/refs/tags/v1.20.2.tar.gz"
  sha256 "fafd0ba4782fda15f4aa13f1211ecc9d39ed09442976c40d9075deb027c732b3"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "31ff0284c71591a687246be325eb26dcea19b2d0ed4e9ca1e23e208dc9b2be3a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8190dbfe0bce1c874d73a639f8ead7323d1c9e553c208dd8679c61033744b2f6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9208c7671e72e6f20bc199bce1c7866b2db85eb17244036ca37c2d3921cd8100"
    sha256 cellar: :any_skip_relocation, sonoma:         "bb86cd91f1084986e2db72e2c60f0335dbfc50c1fc2d581b199189d256b81047"
    sha256 cellar: :any_skip_relocation, ventura:        "16a42af987fed29275730071f47d441810e9a8ceed92b5a32f7b50e4b59dedde"
    sha256 cellar: :any_skip_relocation, monterey:       "44d945b66bb1b924699dd83d4471d40ec21bce29300f22768ea926793f2859df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4351ac5bed485839397ee1a70ae72e9ba4268efd3644b417f792f99f1442efe2"
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
