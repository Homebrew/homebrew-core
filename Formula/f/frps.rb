class Frps < Formula
  desc "Server app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp/archive/refs/tags/v0.68.0.tar.gz"
  sha256 "f7678f5c9d3934687976e493a8c5ce9e0d6da39fdea4c7a2fa03a2c289866ac3"
  license "Apache-2.0"
  head "https://github.com/fatedier/frp.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3efa936a68d0ee41bac5392a93fc7ea0f4e74f652ae3a22385e4fcfa5fa01ed9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3efa936a68d0ee41bac5392a93fc7ea0f4e74f652ae3a22385e4fcfa5fa01ed9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3efa936a68d0ee41bac5392a93fc7ea0f4e74f652ae3a22385e4fcfa5fa01ed9"
    sha256 cellar: :any_skip_relocation, sonoma:        "a0851354c0929bc0569ebbf61cc5c4855f78a43c63ecca3b3d9eb416ac9a09f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "95740a5084b2b832522fd0da8eb18e88b18ff633d5cbe733ea6419062cc8b366"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "687575224b03e7e20ed30086b6ed78b5b3aad4fc571ec5b7cc16a67ef51d7f4b"
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
