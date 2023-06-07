class Hcloud < Formula
  desc "Command-line interface for Hetzner Cloud"
  homepage "https://github.com/hetznercloud/cli"
  url "https://github.com/hetznercloud/cli/archive/v1.34.1.tar.gz"
  sha256 "00ec9466bedca9fbe3ab5151a79df4db6a8997b263bcc6bffb50f25ccc191c80"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9ce0cbf33a20c208c6b0681cdb7362ebcc37ed4ec1eca514476c002b11d990e6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9ce0cbf33a20c208c6b0681cdb7362ebcc37ed4ec1eca514476c002b11d990e6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9ce0cbf33a20c208c6b0681cdb7362ebcc37ed4ec1eca514476c002b11d990e6"
    sha256 cellar: :any_skip_relocation, ventura:        "cfeb09aa12ac72a3e2e25802a1ea7f87c8e6307394f6387bf7c68f77b6d1cd51"
    sha256 cellar: :any_skip_relocation, monterey:       "cfeb09aa12ac72a3e2e25802a1ea7f87c8e6307394f6387bf7c68f77b6d1cd51"
    sha256 cellar: :any_skip_relocation, big_sur:        "cfeb09aa12ac72a3e2e25802a1ea7f87c8e6307394f6387bf7c68f77b6d1cd51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51cc2341f10871bebf7b5b4216db100fc0512220056d91b04fc6c91710f3f920"
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
