class Hcloud < Formula
  desc "Command-line interface for Hetzner Cloud"
  homepage "https://github.com/hetznercloud/cli"
  url "https://github.com/hetznercloud/cli/archive/refs/tags/v1.46.0.tar.gz"
  sha256 "f0581cff19644fe3048ff92064916b8e1c628e4b108f926e872a8f7e3f95ac7a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4686122014d05e83b10b19beece4f3e7c7a78ed9b1d61b33f59dd70758df6b78"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "00ae01153f5acf6ecc97179c57d02419b6db60e6931b6c9cdc782751f15eab1e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "21bc47730e6d68fb0f6081d8550be9e8ab4307a20ccbb3aa82b26fb10ce45dca"
    sha256 cellar: :any_skip_relocation, sonoma:         "0a0ef786c7006b11f2c2b89b5ae0fd589b118968f443c4d598ecf2ad20cefa46"
    sha256 cellar: :any_skip_relocation, ventura:        "d6b386bb72c57e00d58ae3281b91ed7a9ee0354cae433055f893b0f3f0dec813"
    sha256 cellar: :any_skip_relocation, monterey:       "f8c6e84bf927c82a31d74726174849861f67c18146b403952e2eb57f9f793508"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43b34292e267a7427cc94120380909b1ae7179b70574760bce05c0e8bd79e7e9"
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
