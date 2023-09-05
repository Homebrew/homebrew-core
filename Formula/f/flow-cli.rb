class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/v1.4.1.tar.gz"
  sha256 "90c893802c8da64568ad7ec784c297fdfb7337035d07b978048aa3cb88068605"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f67e05f8926ea2671b630896238628d46304e7542eb07b3e80c1ebc348024383"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d9e7e9de2519a786b9cbe5280bb319037f13bd3270c17a833b83a891e583aef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b9c0923100b17684c542c9d807e3d412a980c9965ce8264755105b58e3fed272"
    sha256 cellar: :any_skip_relocation, ventura:        "39e099472aa9fe512aed5d7c351f43a65726c6cb401d9786e02d75e214a19231"
    sha256 cellar: :any_skip_relocation, monterey:       "99693ec583e6525be2b3e2f10f287b11c32187f213818fa2f0de181de5f1df29"
    sha256 cellar: :any_skip_relocation, big_sur:        "fae61c09382553c18019f593bf61b5c826de11e06b2ca4e76fac7804c1feab94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59c84bcbaa90dbb9bbf00cd712a780595bfb887f21ff13a7cae2c24c43e4d932"
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
