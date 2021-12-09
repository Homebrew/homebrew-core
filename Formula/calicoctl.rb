class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.projectcalico.org"
  url "https://github.com/projectcalico/calicoctl.git",
      tag:      "v3.21.2",
      revision: "17461419f0b20d784b2929b4aa700d4b14c2e10d"
  license "Apache-2.0"
  head "https://github.com/projectcalico/calicoctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c15626004a6252c771d55ab7ad3bae91537c2e014b055aecce813397bbe0286d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8485e0cb7f761d39b6389e98c93012b5ec09389b4cedd6477dbd0b6d8d670398"
    sha256 cellar: :any_skip_relocation, monterey:       "415f6fab017fd9416f602aff8f7715253827426e97940531b42de05d4e8b501e"
    sha256 cellar: :any_skip_relocation, big_sur:        "fc2209ca01b92ca35f23962fcc5c7f824a0ca1b98d5ad66b57d291399cd91ef6"
    sha256 cellar: :any_skip_relocation, catalina:       "af2d0300e9086d8202297a754162bf4c1f0d2bc7dd46db854a4240abd82594be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae633c10051c985c1df3c64671e425022fb9326c55ab83cf17620419bdb353d1"
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
