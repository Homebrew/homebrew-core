class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.projectcalico.org"
  url "https://github.com/projectcalico/calico.git",
      tag:      "v3.22.1",
      revision: "82e7ce5201629d55f67afae27f519f4afc680392"
  license "Apache-2.0"
  head "https://github.com/projectcalico/calico.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b4cefb141c7b7e903d51fe3fb5f9c374becb8a4c4adcafcfcd960675a4df9591"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eadde0fa34fd6fe3efab7218a1f63169d7d1496d264baba918a07063ccea131d"
    sha256 cellar: :any_skip_relocation, monterey:       "e8025fe02bce16a3051f89c75c391bb52176588c1c461af866efd7910a5da75f"
    sha256 cellar: :any_skip_relocation, big_sur:        "002342e7381a45112555f34fbc5747c1e5bda6bd643fd845598ff78e65a0a798"
    sha256 cellar: :any_skip_relocation, catalina:       "6d7ab8e38c91210855da42f8f82f6a1240f69e4b65ce18ac1c21390f55ef5a1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "efc58d8a85af0ff097510c8c10e8817bd0f0ea8a0b686830f0e778aeb45033eb"
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
