class Hcloud < Formula
  desc "Command-line interface for Hetzner Cloud"
  homepage "https://github.com/hetznercloud/cli"
  url "https://github.com/hetznercloud/cli/archive/v1.37.0.tar.gz"
  sha256 "7a4d08a8d5e5b3850dedd49abf3b648e213bef4d4172c9bd575760fa4c1a7575"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bc276b75345d4d7c7e20b33787f354b17acc71d9b14b2d5beb764205ef16f0bd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b0db43b231049cb3ce19464a6220f9fa8cf915e3786da009bb4112fb13524aed"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2b09a56ee4ca642f4d69b2053664c332022a5ccd6e79813160037864bf4c7ce6"
    sha256 cellar: :any_skip_relocation, ventura:        "fdad12cdd5f75a012ed1f77d8a0c4f4ae4941d083e36fcd57470b75e76b74e13"
    sha256 cellar: :any_skip_relocation, monterey:       "8eb82612cb50c80c306fb66b44441fc9d76cb804156dad111945957bec37dd48"
    sha256 cellar: :any_skip_relocation, big_sur:        "3020dc3974a769f1336401b04fe13a970b6bbd6afd004cf4d12f25ea40543aba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1dc67c3675cddaec0d132587fdbb24bb489ce124ba4ec13572ca3a0a91529d70"
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
