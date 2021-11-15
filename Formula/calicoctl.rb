class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.projectcalico.org"
  url "https://github.com/projectcalico/calicoctl.git",
      tag:      "v3.21.0",
      revision: "e95354824636094ed7600748083ef5f816455b03"
  license "Apache-2.0"
  head "https://github.com/projectcalico/calicoctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a193f683308afe578aee7e9ab6b50fa71b5fdb731690cbb3ffae0b04541401d0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1a9ff3b99be11fce4d222e038a81950f417290af482d05f6d93d9a634fa193cd"
    sha256 cellar: :any_skip_relocation, monterey:       "674e4509bb01cae91b830523433467aa7a322275045c9e5c8d3651b83aa95c1d"
    sha256 cellar: :any_skip_relocation, big_sur:        "eea25508cefba64a7f1b6c2ea2007bdbbd19a121eb942e518c1b4ea709447b51"
    sha256 cellar: :any_skip_relocation, catalina:       "fa248524794b27cd4389177d9942b299890cc9eb0130c2d7368453d390bbd281"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7596a36b89e95b54e12bca0ba6452579ba07b7d1bdc9d93f944f4adb49bc2d9b"
  end

  depends_on "go" => :build

  def install
    commands = "github.com/projectcalico/calicoctl/v3/calicoctl/commands"
    ldflags = "-X #{commands}.VERSION=#{version} " \
              "-X #{commands}.GIT_REVISION=#{Utils.git_short_head} " \
              "-s -w"
    system "go", "build", *std_go_args(ldflags: ldflags), "calicoctl/calicoctl.go"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/calicoctl version", 1)
  end
end
