class Frpc < Formula
  desc "Client app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp/archive/refs/tags/v0.64.0.tar.gz"
  sha256 "c755c0aaeec3999cb259a312f3327db205a834abf0beeb6410dcdc818d9719a4"
  license "Apache-2.0"
  head "https://github.com/fatedier/frp.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9755c895448f86d044d36e6ee3b2da7ddb3bab707d1efb8c0661092ec584ae6d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1600a141320ae8eb91cb2419a7101ca55c647f1c41a05b26d3ab07be94af2dd2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1600a141320ae8eb91cb2419a7101ca55c647f1c41a05b26d3ab07be94af2dd2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1600a141320ae8eb91cb2419a7101ca55c647f1c41a05b26d3ab07be94af2dd2"
    sha256 cellar: :any_skip_relocation, sonoma:        "5c7b6479d23319120003ec46570c962f6b0105a20ecc7f736d13474bd2cf1639"
    sha256 cellar: :any_skip_relocation, ventura:       "5c7b6479d23319120003ec46570c962f6b0105a20ecc7f736d13474bd2cf1639"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "67f1bba39cf094e173d17dd24d0c0560e6a1d6221ecec8110e25ce1bbbfada49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77190483ec6f2a319e04147b39d4e53ef9ad765bf97b310433ef60978833a954"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags: "-s -w", tags: "frpc"), "./cmd/frpc"
    (etc/"frp").install "conf/frpc.toml"
  end

  service do
    run [opt_bin/"frpc", "-c", etc/"frp/frpc.toml"]
    keep_alive true
    error_log_path var/"log/frpc.log"
    log_path var/"log/frpc.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/frpc -v")
    assert_match "Commands", shell_output("#{bin}/frpc help")
    assert_match "name should not be empty", shell_output("#{bin}/frpc http", 1)
  end
end
