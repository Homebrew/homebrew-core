class Calicoctl < Formula
  desc "Calico CLI tool"
  homepage "https://www.tigera.io/project-calico/"
  url "https://github.com/projectcalico/calico.git",
      tag:      "v3.31.2",
      revision: "dd5575465ed825f86a3bc10f17bb5f7dc106d0f0"
  license "Apache-2.0"
  head "https://github.com/projectcalico/calico.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "617ae02fd7abc17945a5231e0254b44a2cd3dbbf35ef70193e836a5ba397ecbc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "617ae02fd7abc17945a5231e0254b44a2cd3dbbf35ef70193e836a5ba397ecbc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "617ae02fd7abc17945a5231e0254b44a2cd3dbbf35ef70193e836a5ba397ecbc"
    sha256 cellar: :any_skip_relocation, sonoma:        "099df1ff4221c923dc141fef7d47f18a41d207bfc950b9049c2000f28ede617b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b02c174003a18cd423de4975dbf5560d36c6da4c9b9d8c74a99e868365fc2337"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67b01adfe1fcc8a6384ef74a2b7e0e606f68741dbf8587df851295df12c9c860"
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
