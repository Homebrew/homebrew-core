class Hcloud < Formula
  desc "Command-line interface for Hetzner Cloud"
  homepage "https://github.com/hetznercloud/cli"
  url "https://github.com/hetznercloud/cli/archive/refs/tags/v1.62.2.tar.gz"
  sha256 "b49681282bd9ab376d3f250cad53f1356f7004763c39aa41255ec1c263b05673"
  license "MIT"
  head "https://github.com/hetznercloud/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c779100f061f4cdd602f56eec7388471e8b2cf840908ba9d5ade5cdc31f737b3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "56ccf8cf6c9171c7462f8d2342d5c86090c37dc4556c6f5c8ae40be85f5639bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f448ee46196aeba8856cfb5e711f52ca59d35ee15efb6fee7645ea2d0c2695b3"
    sha256 cellar: :any_skip_relocation, sonoma:        "3d3b66ce77420ce684ec6aa270bcbe79fcdefeb758d790a78d204c895158a17f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ad43a81e6055d9a4947faa6c6026521984d864b08078291b1f65a781e3b79a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75091707e529ce1fe47a523b245ded5e21f04fca55517acd69c39f3b5b389e77"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/hetznercloud/cli/internal/version.version=v#{version}
      -X github.com/hetznercloud/cli/internal/version.versionPrerelease=
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/hcloud"

    generate_completions_from_executable(bin/"hcloud", shell_parameter_format: :cobra)
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
