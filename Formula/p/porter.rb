class Porter < Formula
  desc "App artifacts, tools, configs, and logic packaged as distributable installer"
  homepage "https://porter.sh"
  url "https://github.com/getporter/porter/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "02f3d2385930940127817b65d2327b99ce0f4737c87fc08108ad1a91209169bb"
  license "Apache-2.0"
  head "https://github.com/getporter/porter.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9df32e24d976d6db9366d11fa1f10841d89572af2dc6ee1ab6db8a01fd3aba16"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3757354aa567b7ae067351c0450fa3b1827a272171ec8ce148c6ecceef115d64"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0b7f9e3aef12b84fbd1c13e9abc3211ce7ef0b48ccc0584d9fb6cd12f5f5996c"
    sha256 cellar: :any_skip_relocation, sonoma:        "8753998982d42adb3f32fae1ead72bd47101ad5941844d278ba6ddae082a541f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9c15af90b96b2efddc910a2b19b0f6119466a9035af50ffbabc299d39ee08de9"
    sha256 cellar: :any,                 x86_64_linux:  "495add6503fa6d56aad92e333600a89426260ac2773bf8646825f5f9ab525ae6"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X get.porter.sh/porter/pkg.Version=#{version}
      -X get.porter.sh/porter/pkg.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/porter"
    generate_completions_from_executable(bin/"porter", shell_parameter_format: :cobra)
  end

  test do
    assert_match "porter #{version}", shell_output("#{bin}/porter --version")

    system bin/"porter", "create"
    assert_path_exists testpath/"porter.yaml"
  end
end
