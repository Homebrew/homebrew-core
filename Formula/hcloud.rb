class Hcloud < Formula
  desc "Command-line interface for Hetzner Cloud"
  homepage "https://github.com/hetznercloud/cli"
  url "https://github.com/hetznercloud/cli/archive/v1.32.0.tar.gz"
  sha256 "4354a81f6a6227cf4b2ffba09e769a4898c572d2b85a579a77b7a09506345a86"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cfdeb27ff479652dc3af334b8887227c7a4714726813f9f8ab9ab4030abf0d20"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cfdeb27ff479652dc3af334b8887227c7a4714726813f9f8ab9ab4030abf0d20"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cfdeb27ff479652dc3af334b8887227c7a4714726813f9f8ab9ab4030abf0d20"
    sha256 cellar: :any_skip_relocation, ventura:        "a2b5c901c499ec5b0151f6fa9cf65ae2fbbf045046828cf19dc29729384b7d1f"
    sha256 cellar: :any_skip_relocation, monterey:       "a2b5c901c499ec5b0151f6fa9cf65ae2fbbf045046828cf19dc29729384b7d1f"
    sha256 cellar: :any_skip_relocation, big_sur:        "a2b5c901c499ec5b0151f6fa9cf65ae2fbbf045046828cf19dc29729384b7d1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2583c99537dd500b726d194f706b50e1106193944df7b542b9376ba7a9ba12c3"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/hetznercloud/cli/internal/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/hcloud"

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
