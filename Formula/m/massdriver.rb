class Massdriver < Formula
  desc "Manage applications and infrastructure on Massdriver Cloud"
  homepage "https://www.massdriver.cloud/"
  url "https://github.com/massdriver-cloud/mass/archive/refs/tags/1.10.4.tar.gz"
  sha256 "46579d692dcefcae1ca1301a3ec6734ce4f7a581c79890f38a443ae811ef450b"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe8661cd87897e8a2745a5081319a56a64d05cb4999fdb2027b7268817e0b680"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fe8661cd87897e8a2745a5081319a56a64d05cb4999fdb2027b7268817e0b680"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fe8661cd87897e8a2745a5081319a56a64d05cb4999fdb2027b7268817e0b680"
    sha256 cellar: :any_skip_relocation, sonoma:        "076ed43723961d4f709b12d0e3c06bf9e55ad59fa3de3c3e8ed1ef9b0ea6663f"
    sha256 cellar: :any_skip_relocation, ventura:       "076ed43723961d4f709b12d0e3c06bf9e55ad59fa3de3c3e8ed1ef9b0ea6663f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8cb1f94c7329f832e35d1ae1ea1fc066eae697436b98ea052b785716afb0c293"
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
