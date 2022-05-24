class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.projectcalico.org"
  url "https://github.com/projectcalico/calico.git",
      tag:      "v3.23.1",
      revision: "967e2454314046f6568d1c571e8d97e000540f2d"
  license "Apache-2.0"
  head "https://github.com/projectcalico/calico.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d48e507e35cab495e6d9121e33a664670e21b582ad685ddf923852b7a4afa1a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "52d6ccb982f00c2570a192ed7f9c109d27be01cbae0ae22a0f3668f1523a3335"
    sha256 cellar: :any_skip_relocation, monterey:       "fa9728d553fb4ba2969cfba96009e303673445315203bc21fbdf81058d0ceb11"
    sha256 cellar: :any_skip_relocation, big_sur:        "b355baa4c24b25b9abf6d245e5b5819676a02c76a1566b9bb9731f9b2fdbdf95"
    sha256 cellar: :any_skip_relocation, catalina:       "0957fddd5058475ad7da10d34cd527907c71b318066a440a8bd6719491f22147"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6158f783a71480ba591116c81a8a4d02bc16d10e6e64003b97ff6e21d4978a5b"
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
