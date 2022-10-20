class Hcloud < Formula
  desc "Command-line interface for Hetzner Cloud"
  homepage "https://github.com/hetznercloud/cli"
  url "https://github.com/hetznercloud/cli/archive/v1.30.3.tar.gz"
  sha256 "3e5d1fa240c5d0ea46d209c66c315095f6daa884a9424e2a69b5dc312dafe4d6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9194ec5aa7efcfc2f1f68e9ef28c57143dde8f221b6fcd3af7c38c4dc0bda83c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1e31e8e6cd55554c22b47aab40a5a8a3d6e3a81a4d7a45b806490edfeed18fd1"
    sha256 cellar: :any_skip_relocation, monterey:       "17ada31333d51d1eea1399c755354c2a102b1017219712b36fc6c4dad2551d9b"
    sha256 cellar: :any_skip_relocation, big_sur:        "245a194cb5f5fd094091b0a17aaf05963bccc55b2e97602f538877c4ac5ed2b6"
    sha256 cellar: :any_skip_relocation, catalina:       "e65ba85bbb302a03535ee99f61633d8585b76ec9221a55b6fde484c078cc3b30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0fae453cb61f091b1721c0713caa673faf54eb86a0a2aaea8338c6878165d55b"
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
