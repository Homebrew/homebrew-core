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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "782ec16444f4376094729779772f29e30fb7900b13736e30c5a4a3814cd8140f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5093f71e67827a71dae31f963a44a4765259affc1c14a54bdaaec38251aed780"
    sha256 cellar: :any_skip_relocation, monterey:       "dd82c411170cea69ecb2c381da2caa01672dc0126cf0f8732b50f3ff6d511322"
    sha256 cellar: :any_skip_relocation, big_sur:        "3f3393d94c1d65f74157063ebf45be5428feaeb389d40d285a6e2ca22435ee60"
    sha256 cellar: :any_skip_relocation, catalina:       "823aecf02877405103699aaeb00ec3a0dfb9d0b1d590694f803a9a093dc08d02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca0261a747fe3b0fbadb51158106532983306a8a1f60299d962aadd62c0f06dc"
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
