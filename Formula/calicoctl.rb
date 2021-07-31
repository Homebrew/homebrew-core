class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.projectcalico.org"
  url "https://github.com/projectcalico/calicoctl.git",
      tag:      "v3.20.0",
      revision: "38b00edd005363b369dd7c585933b08376f76d6c"
  license "Apache-2.0"
  head "https://github.com/projectcalico/calicoctl.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1a0f248d5b5f9059ed24a4cd762adb2e195f7a1c721d4f4ec40f7f707d9c892c"
    sha256 cellar: :any_skip_relocation, big_sur:       "400e7c298d661badd89ac967a33921297657a6f53a4155ee4fa620c7b71b8040"
    sha256 cellar: :any_skip_relocation, catalina:      "ad8a82058db04666e990a8963dfa233b5db2d852257b14a7b98d05771d96a38a"
    sha256 cellar: :any_skip_relocation, mojave:        "a44473b4ee9ce7ca1a4a9444a1a4d06e51f6ecc0142a00b62d2f2c1e0024c1ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af530644558d1fcf213d9d08c4f98d7cfe8dc1483ecc80f2a0dfde44ac0f10eb"
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
