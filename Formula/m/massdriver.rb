class Massdriver < Formula
  desc "Manage applications and infrastructure on Massdriver Cloud"
  homepage "https://www.massdriver.cloud/"
  url "https://github.com/massdriver-cloud/mass/archive/refs/tags/1.10.0.tar.gz"
  sha256 "e24def8d3d1c7d74eade4077d4e77b003b54275f69853a016ebff008ac245127"
  license "Apache-2.0"
  head "https://github.com/massdriver-cloud/mass.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea06387204a6268003f6a8286be8e7ad4bfe1eba2d558523df88ebab603fa9be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea06387204a6268003f6a8286be8e7ad4bfe1eba2d558523df88ebab603fa9be"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ea06387204a6268003f6a8286be8e7ad4bfe1eba2d558523df88ebab603fa9be"
    sha256 cellar: :any_skip_relocation, sonoma:        "d52baefbb0c60261a0352b40255ef4bad9a51527a84d99a74ae35e47f73e7580"
    sha256 cellar: :any_skip_relocation, ventura:       "d52baefbb0c60261a0352b40255ef4bad9a51527a84d99a74ae35e47f73e7580"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7252dd8f96b6a4f851c16fd35d9d1916f8a355e6c4003274b07c48ad7f603e8e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/massdriver-cloud/mass/pkg/version.version=#{version}
      -X github.com/massdriver-cloud/mass/pkg/version.gitSHA=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"mass")
    generate_completions_from_executable(bin/"mass", "completion")
  end

  test do
    output = shell_output("#{bin}/mass bundle build 2>&1", 1)
    assert_match "Error: open massdriver.yaml: no such file or directory", output

    output = shell_output("#{bin}/mass bundle lint 2>&1", 1)
    assert_match "OrgID: missing required value: MASSDRIVER_ORG_ID", output

    assert_match version.to_s, shell_output("#{bin}/mass version")
  end
end
