class Frps < Formula
  desc "Server app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp/archive/refs/tags/v0.71.0.tar.gz"
  sha256 "1dd367d6d822a7fce1d3012fce0a6e778bc90c454e2c7baa0eb1e6de6054c61b"
  license "Apache-2.0"
  head "https://github.com/fatedier/frp.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3441d6d6bf5101947401f27cea2265ec66e53e492521c67c60fd33fdb9334b37"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3441d6d6bf5101947401f27cea2265ec66e53e492521c67c60fd33fdb9334b37"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3441d6d6bf5101947401f27cea2265ec66e53e492521c67c60fd33fdb9334b37"
    sha256 cellar: :any_skip_relocation, sonoma:        "18323a3812a3abab7a9b768bcb84e98f35409c25443ccf22a629956d6d937b06"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2951b9f94b57589cc9ce26a2e981bae0a1676a0cb734186cccf3065e3ea7238e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03b579fb0524da8dc8f37f214362f14b1f60850bb288ceb39977aa3208e2b9a0"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    cd "web/frps" do
      system "npm", "install", *std_npm_args(prefix: false)
      system "npm", "run", "build-only"
    end

    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(tags: "frps"), "./cmd/frps"

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
