class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.tigera.io/project-calico/"
  url "https://github.com/projectcalico/calico.git",
      tag:      "v3.32.1",
      revision: "0ca9d1b93644778cafdf1812f3dda02ac0c361e8"
  license "Apache-2.0"
  head "https://github.com/projectcalico/calico.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2c70a2d0e2e29a04bb9f36aed8f1d6ed42ab49aa71d722dad6620881ab274109"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1cbcd0696c54a6fd8cb8f4053b33b2b6664eb2a3058f3d6d4db2822d0d6cdcf0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0333cff74011021986e5622d9020feeceb2fdf32224540eb344144a963ec48dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "57003d8dfd9fe45bc1d0780ff6708e2e2cb653d64fd1d2fec4162b9b432417a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f2e6f1a1becfbd950d3fec2bc944cb06b80a2b3dabf69c2ae84363b92cca157"
    sha256 cellar: :any,                 x86_64_linux:  "6bbded3ecc9fc0e3e6231ff17bf0aa8c778cf322a0815d4892f6be3e2cbb2aee"
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
