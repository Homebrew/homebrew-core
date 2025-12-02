class Frps < Formula
  desc "Server app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp/archive/refs/tags/v0.65.0.tar.gz"
  sha256 "bbec0d1855e66c96e3a79ff97b8c74d9b1b45ec560aa7132550254d48321f7de"
  license "Apache-2.0"
  head "https://github.com/fatedier/frp.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e26c30ec9715ba678a0f56047bc286047db7eb4925f3fcdb6b3ed00ead4ff1df"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e26c30ec9715ba678a0f56047bc286047db7eb4925f3fcdb6b3ed00ead4ff1df"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e26c30ec9715ba678a0f56047bc286047db7eb4925f3fcdb6b3ed00ead4ff1df"
    sha256 cellar: :any_skip_relocation, sonoma:        "da0f0da90f709eb63699b20f5fd9c43050a74f4eecee5dec3ffa16339a8c0f94"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13649d7616ddd32de46d0e9f7aa5759782f9c19a9b2c891ded40ceebad960279"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c832378f3a33854b923674a9e4ff6c4c68f93b6ac51adfd6137c5efad2259818"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags: "-s -w", tags: "frps"), "./cmd/frps"

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
