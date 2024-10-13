class Hcloud < Formula
  desc "Command-line interface for Hetzner Cloud"
  homepage "https://github.com/hetznercloud/cli"
  url "https://github.com/hetznercloud/cli/archive/refs/tags/v1.47.0.tar.gz"
  sha256 "2f1c15f71cca7c2e725a5047dbd918cc919962930b9681c53402e9c693884894"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "e2415bf59686d42101493cdd34e33569745257219276f3b4e30f145d0486a196"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d7c7f90ec74f8119f0d5c95a2d43df7c1c5973ac47bc3f92828cab5194960e11"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d7c7f90ec74f8119f0d5c95a2d43df7c1c5973ac47bc3f92828cab5194960e11"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d7c7f90ec74f8119f0d5c95a2d43df7c1c5973ac47bc3f92828cab5194960e11"
    sha256 cellar: :any_skip_relocation, sonoma:         "034f8534280e82fb0d641682b71a0e9f95f84b4561b9976918c4cee67ce54db2"
    sha256 cellar: :any_skip_relocation, ventura:        "034f8534280e82fb0d641682b71a0e9f95f84b4561b9976918c4cee67ce54db2"
    sha256 cellar: :any_skip_relocation, monterey:       "034f8534280e82fb0d641682b71a0e9f95f84b4561b9976918c4cee67ce54db2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b81830b472d0052cbcf4413b1a402a4e59dba3c394d15562cc535888c352f9e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/hetznercloud/cli/internal/version.version=v#{version}
      -X github.com/hetznercloud/cli/internal/version.versionPrerelease=
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/hcloud"

    generate_completions_from_executable(bin/"hcloud", "completion")
  end

  test do
    config_path = testpath/".config/hcloud/cli.toml"
    ENV["HCLOUD_CONFIG"] = config_path
    assert_match "", shell_output("#{bin}/hcloud context active")
    config_path.write <<~EOS
      active_context = "test"
      [[contexts]]
      name = "test"
      token = "foobar"
    EOS
    assert_match "test", shell_output("#{bin}/hcloud context list")
    assert_match "test", shell_output("#{bin}/hcloud context active")
    assert_match "hcloud v#{version}", shell_output("#{bin}/hcloud version")
  end
end
