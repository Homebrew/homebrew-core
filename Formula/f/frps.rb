class Frps < Formula
  desc "Server app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp/archive/refs/tags/v0.61.0.tar.gz"
  sha256 "c06a11982ef548372038ec99a6b01cf4f7817a9b88ee5064e41e5132d0ccb7e1"
  license "Apache-2.0"
  head "https://github.com/fatedier/frp.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "40b4760a745d5f37ad33b77b032dde5ae75ca57210d2d6599a5ff58e4a88b2de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "40b4760a745d5f37ad33b77b032dde5ae75ca57210d2d6599a5ff58e4a88b2de"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "40b4760a745d5f37ad33b77b032dde5ae75ca57210d2d6599a5ff58e4a88b2de"
    sha256 cellar: :any_skip_relocation, sonoma:        "fb7ef84acace3c8b6ed7f29e2ac1825d93bd13218c18b2838229f61447411e55"
    sha256 cellar: :any_skip_relocation, ventura:       "fb7ef84acace3c8b6ed7f29e2ac1825d93bd13218c18b2838229f61447411e55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c646175538841f0efd668178c350db92d759ef83022cd9ac2ba638e44343711d"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-tags=frps", "./cmd/frps"

    (etc/"frp").install "conf/frps.toml"
  end

  service do
    run [opt_bin/"frps", "-c", etc/"frp/frps.toml"]
    keep_alive true
    error_log_path var/"log/frps.log"
    log_path var/"log/frps.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/frps -v")
    assert_match "Flags", shell_output("#{bin}/frps --help")

    read, write = IO.pipe
    fork do
      exec bin/"frps", out: write
    end
    sleep 3

    output = read.gets
    assert_match "frps uses command line arguments for config", output
  end
end
