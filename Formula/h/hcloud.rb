class Hcloud < Formula
  desc "Command-line interface for Hetzner Cloud"
  homepage "https://github.com/hetznercloud/cli"
  url "https://github.com/hetznercloud/cli/archive/refs/tags/v1.53.0.tar.gz"
  sha256 "d64f1d00bdd97fdd9c4aff0b864f0d624349a68739b437831a0aebdb6fa0584b"
  license "MIT"
  head "https://github.com/hetznercloud/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fc280cae674c13c0baf87b61b8f96b0abcc9e42b2634022dbf0635e6f85f844b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c59f6f1d43f03d02c9ee383096159c016e65f0d62934be3731f6129ad3d1819"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0667684518d82db623d0b9608a9401ab1bc926ef14fcebf65f59b61bc88ead9c"
    sha256 cellar: :any_skip_relocation, sonoma:        "3cbce77309799f7dcac3559933797323c58d4cd831cd9d7501e642e53658e88f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d4c4324e3d67aabc92098a669ca41616f120b51781114309a7e975245830ba5"
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
