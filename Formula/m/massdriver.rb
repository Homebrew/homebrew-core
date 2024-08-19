class Massdriver < Formula
  desc "Manage applications and infrastructure on Massdriver Cloud"
  homepage "https://www.massdriver.cloud/"
  url "https://github.com/massdriver-cloud/mass/archive/refs/tags/1.8.2.tar.gz"
  sha256 "c27fe250259226b9fbee1840f6c0e68d97d1ad686385d52571c7fe6a17802e2c"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2c57b6020fb18eb10ec3262015aa895a8053c3f0b63e14603df59b68c3941c30"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6338819f8581a52e79dfe6cd16a533c8db353e380ebe155bf3dfa7f5cfba9f4b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d98d77072a29d1d0f1ca6edea4b6c5d6273ee491cd2204b353c86f95f56bfbbb"
    sha256 cellar: :any_skip_relocation, sonoma:         "0598bf4a4e08c0f2d7693d8e7e47117c47f31b39ffd18f3e2378c27a0f9f4794"
    sha256 cellar: :any_skip_relocation, ventura:        "b18686c837dd72c03cbfe3c177a47ba4e04838f7cb4df362857d7754b2336b1f"
    sha256 cellar: :any_skip_relocation, monterey:       "89262b4a4bb98ab84c51979e2d657f474f72310b6493c702e28a7a126b8be38a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b87984d052f7af4c6ff7b551fa550cac89bd75ab9311f6076f7d76a8f847ff52"
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
