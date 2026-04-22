class Frps < Formula
  desc "Server app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp/archive/refs/tags/v0.68.1.tar.gz"
  sha256 "44ed7107bf35e4f68dc0e77cd5805102effa5301528b89ee5ab0ab379088edc6"
  license "Apache-2.0"
  head "https://github.com/fatedier/frp.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "095ed2f73ff4337a64547af689e8f51ee773bf83b672ea385f1b566d0b511ee6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "095ed2f73ff4337a64547af689e8f51ee773bf83b672ea385f1b566d0b511ee6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "095ed2f73ff4337a64547af689e8f51ee773bf83b672ea385f1b566d0b511ee6"
    sha256 cellar: :any_skip_relocation, sonoma:        "deca4a8220ca79c3ee7d334251b37cf15dc930eec83573961ed7f9cf18c55acf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8811946cbd29c9ed352fa5de21fbd72887bd1a0c6ebe5017bd4a006c267fdef0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a33e85ab66e44906447c4b5a8a25b1a6c71572e837b3b8ac162151770fdb114"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    cd "web/frps" do
      system "npm", "install", *std_npm_args(prefix: false)
      system "npm", "run", "build"
    end

    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags: "-s -w", tags: "frps"), "./cmd/frps"

    (etc/"frp").install "conf/frps.toml"

    generate_completions_from_executable(bin/"frps", "completion")
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
