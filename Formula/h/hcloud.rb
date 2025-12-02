class Hcloud < Formula
  desc "Command-line interface for Hetzner Cloud"
  homepage "https://github.com/hetznercloud/cli"
  url "https://github.com/hetznercloud/cli/archive/refs/tags/v1.57.0.tar.gz"
  sha256 "f6bad0ed7969fec9c6ec301cb8b5f8b6dc4cb0ab16a543df325e8d51ae96d3b1"
  license "MIT"
  head "https://github.com/hetznercloud/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "290cd3bb0a6090e6c125ddb04a1bc15f5a957381abeada90d52bff7c6d39069c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2dfa03017cfab9b7873296bb7ff798b8699954b6dd20df3c9db27da605dc1a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df765b395ef066fa7d3c4365665ef13e0211dfcd2a07f043a592586ec6c93d53"
    sha256 cellar: :any_skip_relocation, sonoma:        "717e2e9b8d2250453319ce774779ef36fa22d57a7f36147e644060aa28a8e107"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d329996ffa1d7e76498168352852bbeafcbfdd708eddcde6743855282efb115a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "448635e0f502574d40d8edcd5fc66e10892d4a87b804b70332c516639aac5bcb"
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
