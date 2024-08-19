class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.projectcalico.org"
  url "https://github.com/projectcalico/calico.git",
      tag:      "v3.28.1",
      revision: "6018563438f3aacf5e043dea0c567abe5d34c08a"
  license "Apache-2.0"
  head "https://github.com/projectcalico/calico.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f5e0e9fac11bb391d326264455be11600e18747ef025130270e92751b78c3085"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bc696b1ff3ff3b8bd3407cbde061fc7fbb855e64179c6d2105a05946d5831647"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "845cb1069db3002960b2eb6bdeefb8cd3ea2bc76e33bcdb29432becd811990be"
    sha256 cellar: :any_skip_relocation, sonoma:         "1dbd1ee9c22594731877db05760c5bb174bc727380d09ac5668ca6698bcd6b10"
    sha256 cellar: :any_skip_relocation, ventura:        "336c51d9f38666fbc43fbc53345f9e84ee3e126a4f6dca868c4eddc18f9861f7"
    sha256 cellar: :any_skip_relocation, monterey:       "1a5ced2212333bddce6269fc8916b0a5167fbd832887b01674fa1e026ea7665f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7e717034d9cfe08d888dc830c0c5d4518d259e5b3526c4ad83837054d85673f"
  end

  depends_on "go" => :build

  def install
    commands = "github.com/projectcalico/calico/calicoctl/calicoctl/commands"
    ldflags = "-X #{commands}.VERSION=#{version} " \
              "-X #{commands}.GIT_REVISION=#{Utils.git_short_head} " \
              "-s -w"
    system "go", "build", *std_go_args(ldflags:), "calicoctl/calicoctl/calicoctl.go"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/calicoctl version")

    assert_match "invalid configuration: no configuration has been provided",
      shell_output("#{bin}/calicoctl datastore migrate lock 2>&1", 1)
  end
end
