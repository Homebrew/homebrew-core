class Hcloud < Formula
  desc "Command-line interface for Hetzner Cloud"
  homepage "https://github.com/hetznercloud/cli"
  url "https://github.com/hetznercloud/cli/archive/v1.30.2.tar.gz"
  sha256 "e44505128e16013926b469c3f668c996b6225b94d3595c645721e9d146807b6e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d51161dba64cc0ff60cc34f056b2cc2675c5cdf46adb199bc393905a380bd7b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1e796eeed039ec006537227762fb7c60e661eff1daac5f37c1605b5a27e19e6e"
    sha256 cellar: :any_skip_relocation, monterey:       "9aa4a0aef5eccd6a9d6fae7ef5fdad299bf72f6cecae27d4846357769760ba00"
    sha256 cellar: :any_skip_relocation, big_sur:        "4737d878685d919257eeebc5a8c2c450707b5ee3abf1249b62b44f5350f1b1ed"
    sha256 cellar: :any_skip_relocation, catalina:       "a235c5b8de8975ffabc38e264d9c912cd058e2923b2cac497ab018490413db6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6bfac2ec5e18c335fd107461fd34156c74bf94a3cca7fda9d9f8ac92f8079eb"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/hetznercloud/cli/internal/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/hcloud"

    output = Utils.safe_popen_read(bin/"hcloud", "completion", "bash")
    (bash_completion/"hcloud").write output
    output = Utils.safe_popen_read(bin/"hcloud", "completion", "zsh")
    (zsh_completion/"_hcloud").write output
    output = Utils.safe_popen_read(bin/"hcloud", "completion", "fish")
    (fish_completion/"hcloud.fish").write output
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
