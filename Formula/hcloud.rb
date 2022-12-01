class Hcloud < Formula
  desc "Command-line interface for Hetzner Cloud"
  homepage "https://github.com/hetznercloud/cli"
  url "https://github.com/hetznercloud/cli/archive/v1.31.0.tar.gz"
  sha256 "6f014e92e31e842c0aa49d82159a4e9df34d26bb896461b09680561216cb9246"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a4e62c7ece885e46bbeb41ef0ad11a4f1d1b519498e82eab9878d1ac33d081f6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a2d507878318853dcbba57f4c85874cb71228936293c7597c52ca1d40beaf8c3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2cfde8f131587ed7c61c8a6fbd0af28a025b09900469f97e53d588d5c0184ef3"
    sha256 cellar: :any_skip_relocation, ventura:        "927ad496cd5b8b637c5fb3a6bd0b0c17cc6afaa15cccb9c9381ba3958c3402aa"
    sha256 cellar: :any_skip_relocation, monterey:       "526981dc9a6437f75819fbd7d79abff2d0654434f315ef6dfa73a692ec37ae66"
    sha256 cellar: :any_skip_relocation, big_sur:        "061a6db21bc970590f8dd21d0635e37faf419f4ef935e442707a2b0681b30604"
    sha256 cellar: :any_skip_relocation, catalina:       "77e63c1276bc281dac2e5f948d47c3204e7bdb6614f9cfe0c7614e109c61816e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "584f01cd2e7ac7f12ea9a1babe4a41e699ab260aae99020e0348615d9a11bf4b"
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
