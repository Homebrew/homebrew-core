class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.projectcalico.org"
  url "https://github.com/projectcalico/calico.git",
      tag:      "v3.30.1",
      revision: "393b14e729a67f9bc9a96eba65ff0be5f2f7b94a"
  license "Apache-2.0"
  head "https://github.com/projectcalico/calico.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a43b680ee2dd892e49b37220690c4a32032168fe49d34a490443069431e3404b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a43b680ee2dd892e49b37220690c4a32032168fe49d34a490443069431e3404b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a43b680ee2dd892e49b37220690c4a32032168fe49d34a490443069431e3404b"
    sha256 cellar: :any_skip_relocation, sonoma:        "cbd48f77c616a7f751ae884d72488ea3db13499618a9dbc91ca669beeba65b5d"
    sha256 cellar: :any_skip_relocation, ventura:       "cbd48f77c616a7f751ae884d72488ea3db13499618a9dbc91ca669beeba65b5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "813f4e05215835b654f8f481c82f97c95f5475c70819e11151231f99c231bac8"
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
