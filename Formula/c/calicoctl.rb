class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.projectcalico.org"
  url "https://github.com/projectcalico/calico.git",
      tag:      "v3.29.3",
      revision: "b5d7d74c111d943251b61827ea88d9e5518f823b"
  license "Apache-2.0"
  head "https://github.com/projectcalico/calico.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "18b7b5a2e6025b22b1c5794ef264b72919c1dcf420b17079705c50b0b04032ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "18b7b5a2e6025b22b1c5794ef264b72919c1dcf420b17079705c50b0b04032ca"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "18b7b5a2e6025b22b1c5794ef264b72919c1dcf420b17079705c50b0b04032ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "c41dbc3872a9807e9747c9c9f32592a6fdb1c8ae29109bbf01feeb5c893e4cee"
    sha256 cellar: :any_skip_relocation, ventura:       "c41dbc3872a9807e9747c9c9f32592a6fdb1c8ae29109bbf01feeb5c893e4cee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5f931fc2f7f41b4818b3fa421c5781c89da44408a52653068da20ff3b1e2279"
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
