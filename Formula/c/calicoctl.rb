class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.tigera.io/project-calico/"
  url "https://github.com/projectcalico/calico.git",
      tag:      "v3.31.3",
      revision: "2e3c880bcabff580ddd7a08340878ede207f37be"
  license "Apache-2.0"
  head "https://github.com/projectcalico/calico.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b3ee2078f724dd254a3d590ec47aaecd515d4527d7c9c922c3418410d557c57f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3ee2078f724dd254a3d590ec47aaecd515d4527d7c9c922c3418410d557c57f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b3ee2078f724dd254a3d590ec47aaecd515d4527d7c9c922c3418410d557c57f"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd1cc3b52446c62b073fe738caae2344901ab216cf88c13184183382ee68a5a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f538c9d56a580a8f44eb1f2988de353785dbaef5974937da97815aa37fe3be8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec3822de28efb4ab81e2f8a05dd9de02388aac44149333b655f7e7f836ad2cc0"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/projectcalico/calico/pkg/buildinfo.Version=#{version}
      -X github.com/projectcalico/calico/pkg/buildinfo.GitRevision=#{Utils.git_short_head}
      -X github.com/projectcalico/calico/pkg/buildinfo.BuildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "calicoctl/calicoctl/calicoctl.go"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/calicoctl version")

    assert_match "invalid configuration: no configuration has been provided",
      shell_output("#{bin}/calicoctl datastore migrate lock 2>&1", 1)
  end
end
