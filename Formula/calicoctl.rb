class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.projectcalico.org"
  url "https://github.com/projectcalico/calico.git",
      tag:      "v3.25.1",
      revision: "82dadbce194ac671508c71574a0e59eb82c911f9"
  license "Apache-2.0"
  head "https://github.com/projectcalico/calico.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7c8d1b9e6630397ca017036cc9278b3360fd6b03fba9611d10f95664c7fd0c80"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c8d1b9e6630397ca017036cc9278b3360fd6b03fba9611d10f95664c7fd0c80"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7c8d1b9e6630397ca017036cc9278b3360fd6b03fba9611d10f95664c7fd0c80"
    sha256 cellar: :any_skip_relocation, ventura:        "22497533fe259645a9e2d0c496c3df69d4f9c67dac2f1c33eb118a8eeaa8d3f6"
    sha256 cellar: :any_skip_relocation, monterey:       "22497533fe259645a9e2d0c496c3df69d4f9c67dac2f1c33eb118a8eeaa8d3f6"
    sha256 cellar: :any_skip_relocation, big_sur:        "22497533fe259645a9e2d0c496c3df69d4f9c67dac2f1c33eb118a8eeaa8d3f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b0366d93f72e112c4593150f3154beb7c6a468bb8d100e44c7cf35979855382"
  end

  depends_on "go" => :build

  def install
    commands = "github.com/projectcalico/calico/calicoctl/calicoctl/commands"
    ldflags = "-X #{commands}.VERSION=#{version} " \
              "-X #{commands}.GIT_REVISION=#{Utils.git_short_head} " \
              "-s -w"
    system "go", "build", *std_go_args(ldflags: ldflags), "calicoctl/calicoctl/calicoctl.go"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/calicoctl version")

    assert_match "invalid configuration: no configuration has been provided",
      shell_output("#{bin}/calicoctl datastore migrate lock 2>&1", 1)
  end
end
