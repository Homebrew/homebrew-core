class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.projectcalico.org"
  url "https://github.com/projectcalico/calico.git",
      tag:      "v3.25.0",
      revision: "3f7fe4d290541bbdd73c97bdc89a29a29855a48a"
  license "Apache-2.0"
  head "https://github.com/projectcalico/calico.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "98c8a5b66908ceb447ce1b14d1e7f649f0fe810e47a88b86326c6b04dd48d6b4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7fe28169866a4b1174a8c979d849e05f7504ac39cd0915e0f67e8139d9571dbf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f84e5f87eb96a3c9a3d72fe96f55d23125be6ea3e736427fd0750729777f484b"
    sha256 cellar: :any_skip_relocation, ventura:        "e6da004381f5a63046613131642d30696a7359d2aacd4637083e7733c875ea5c"
    sha256 cellar: :any_skip_relocation, monterey:       "a4d41d6dc2d23b08aae75afcbcbba2cbc6a7fd99f27283e6c6652051833ec933"
    sha256 cellar: :any_skip_relocation, big_sur:        "fa3b010ebe8c0900cf8fa3910bbd220e6602963601168f0f712216318b23e021"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e666aec71362c4ba6a4b84a11e15f8b54ce2c1aa5202eaf46d071a7809e516b5"
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
