class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/refs/tags/v2.16.0.tar.gz"
  sha256 "7e943b37e85018deff0277eea96c920ce91efe6728db6ce9aa05b98e239d1d4b"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d950eef1ea839ec5ee9ec57bd1a48fc252e10f2f145cca66070ee990d22775d1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "125610d9e94140ea038233b34d9426a8a705d288720db3d3036de2dccb0fc2a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e27a0953d91297fd34388a0648c0bc7f5718a22193988eb5277248bc71c2cce"
    sha256 cellar: :any_skip_relocation, sonoma:        "721770bb2c7ded9cc3aee0546a195acae70b4fabcf0a85fb8906311501c3b718"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "19f1e389d2c9dca864d88f044dbc93df64be8dbb32180feaca21fc153e91a1fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be8ee9380eed016406e11119d15dc24018c2fd119eb70749dd09811df4f23727"
  end

  depends_on "go@1.25" => :build

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
