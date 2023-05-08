class Hcloud < Formula
  desc "Command-line interface for Hetzner Cloud"
  homepage "https://github.com/hetznercloud/cli"
  url "https://github.com/hetznercloud/cli/archive/v1.33.2.tar.gz"
  sha256 "eb9f67e01b2881ae5bb4d7a50ac2d8ecff106c6aa007eddcc48b89fbf67e463c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a4060c50eff07c82442e92369d6938d1f660e2ebb8fb79fcd00c84c043461314"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a4060c50eff07c82442e92369d6938d1f660e2ebb8fb79fcd00c84c043461314"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a4060c50eff07c82442e92369d6938d1f660e2ebb8fb79fcd00c84c043461314"
    sha256 cellar: :any_skip_relocation, ventura:        "36d91b266da8a63497c90191056e92ccfe2e37eadf773074474a8a3bb884d94e"
    sha256 cellar: :any_skip_relocation, monterey:       "36d91b266da8a63497c90191056e92ccfe2e37eadf773074474a8a3bb884d94e"
    sha256 cellar: :any_skip_relocation, big_sur:        "36d91b266da8a63497c90191056e92ccfe2e37eadf773074474a8a3bb884d94e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4afd54bb901e97f97c4036de9738266196a0725ff806f882f41adf6cab3a7ded"
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
