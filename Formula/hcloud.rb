class Hcloud < Formula
  desc "Command-line interface for Hetzner Cloud"
  homepage "https://github.com/hetznercloud/cli"
  url "https://github.com/hetznercloud/cli/archive/v1.35.0.tar.gz"
  sha256 "3dad20aa8b4592c65046a0587ded4cccc87aeba308bf1f5f07cde0bb864e6717"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "19065bb534ec28ec92bd8fb3c291c89e97566144a09ddc30316af5a2f96607c7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19065bb534ec28ec92bd8fb3c291c89e97566144a09ddc30316af5a2f96607c7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "19065bb534ec28ec92bd8fb3c291c89e97566144a09ddc30316af5a2f96607c7"
    sha256 cellar: :any_skip_relocation, ventura:        "21fbc7a5b7d2def4f7c18f98fc71a0ed1f0293e25aa1dc421e221737e87bab91"
    sha256 cellar: :any_skip_relocation, monterey:       "21fbc7a5b7d2def4f7c18f98fc71a0ed1f0293e25aa1dc421e221737e87bab91"
    sha256 cellar: :any_skip_relocation, big_sur:        "21fbc7a5b7d2def4f7c18f98fc71a0ed1f0293e25aa1dc421e221737e87bab91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b19247435b76ae58838f28f7fd932d2948b209037cd240c98a7bed4132d892d2"
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
