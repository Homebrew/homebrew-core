class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.projectcalico.org"
  url "https://github.com/projectcalico/calico.git",
      tag:      "v3.30.2",
      revision: "cf50b562271b7c2ad896af0488d48eddabbb74eb"
  license "Apache-2.0"
  head "https://github.com/projectcalico/calico.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7ee8e80f6748f234d5444a98570686f8fa587b4deec28e96f9395eff90b506a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7ee8e80f6748f234d5444a98570686f8fa587b4deec28e96f9395eff90b506a9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7ee8e80f6748f234d5444a98570686f8fa587b4deec28e96f9395eff90b506a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "669ea26e220507c4baa5d5ed8470077f9ce58464c521e05e11043be813b893e3"
    sha256 cellar: :any_skip_relocation, ventura:       "669ea26e220507c4baa5d5ed8470077f9ce58464c521e05e11043be813b893e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "920fa79e063454a01c1d82a721c0ad16eae5039bd5625240b17b44a988b9517f"
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
