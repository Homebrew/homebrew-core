class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.projectcalico.org"
  url "https://github.com/projectcalico/calico.git",
      tag:      "v3.24.5",
      revision: "f1a1611acb98d9187f48bbbe2227301aa69f0499"
  license "Apache-2.0"
  head "https://github.com/projectcalico/calico.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c6ed8e02e6488f7cad4c8c435b0f1db0c7d82205a9aaed4537cc7c7b5e5809cd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c0172617367c1dfa3b617719edaa216b8be8fe9828e315e4c7328bcb8bf8c090"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "45dce9a55d20a0a32d6bc0a2548bbe8c0901ea339e17b4f486a2ce9df312ca5f"
    sha256 cellar: :any_skip_relocation, monterey:       "a9be07979ecfb710b6bab21103125b80c37c04a65a921cfa20d69cea1ca4a2ed"
    sha256 cellar: :any_skip_relocation, big_sur:        "4f8ad931ebe9c5a3d43c9cabe0a0905b5dff44c08e0b7e628cb61af4a1d96798"
    sha256 cellar: :any_skip_relocation, catalina:       "5ff264e6d2dfe94c7f674eb41e849794ca3c70957f937c015cd2a531d682ec4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bbf068fb10a3f8d36782de7c761fc495fa01c6f3d7d5e93a958f83cdc5ac79fa"
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
