class DroneCli < Formula
  desc "Command-line client for the Drone continuous integration server"
  homepage "https://drone.io"
  url "https://github.com/drone/drone-cli.git",
      tag:      "v1.3.2",
      revision: "f25f6e552b62394a913d83d66aeca5ff9ea61e41"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "26568fe6920ab5e98485177180ec5654c2853d5515752f881d2d1c1828938c42"
    sha256 cellar: :any_skip_relocation, big_sur:       "3522d410b7cb07da627aec2fc3397dc29b581499301d5b9e762a9d060978fe8e"
    sha256 cellar: :any_skip_relocation, catalina:      "9b2af8110063a073d3cd0e1b341ae2921cf98c96ecfb0ef0a2bcabd03e35c4cd"
    sha256 cellar: :any_skip_relocation, mojave:        "319fdf558cd1e893674f460187965eca5fc0a9d88eae085588605e1e55d0b55e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e9ed9c52b32fc33067c6dd6d54162fd252effe714199a90e08bb5fb42fdddfa"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", "-ldflags", "-s -w -X main.version=#{version}", "-trimpath", "-o",
           bin/"drone", "drone/main.go"
    prefix.install_metafiles
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/drone --version")

    assert_match "manage logs", shell_output("#{bin}/drone log 2>&1")
  end
end
