class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.projectcalico.org"
  url "https://github.com/projectcalico/calico.git",
      tag:      "v3.24.2",
      revision: "926c791c269e9a05b65777f60a6c5238999ef7b6"
  license "Apache-2.0"
  head "https://github.com/projectcalico/calico.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a3427c2f3a6d20dcf4272d12035bd70b6d87a8ffd0de2bd9d8631f74012d2b61"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "485c719d54559f4819626c004b8cae88b147773ceb34ee8f7701896912683c21"
    sha256 cellar: :any_skip_relocation, monterey:       "70417c2e595b7a6b322cc6b9e0e9b7c522b44ed3f243aebe6f39584bad69c5d6"
    sha256 cellar: :any_skip_relocation, big_sur:        "6d224667bac9eb899d9a4ea34178d2979c389afb66adec97de372ac06aa6d657"
    sha256 cellar: :any_skip_relocation, catalina:       "a913882919062c6047cfa3f6598149f850387ba164a3fb648e4c11196be6be25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cfd2316ea5b9e3b935f7c0e72bb479f357e78334070b6449288c7d225e325367"
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
