class Frps < Formula
  desc "Server app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp/archive/refs/tags/v0.69.1.tar.gz"
  sha256 "79a62c1071ddb947e95146ad7b1cb8b25f182fed548a4a8a68d5fca06b37502c"
  license "Apache-2.0"
  head "https://github.com/fatedier/frp.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "caf55299106769ee6eb9c9d6ac204dc94cccf99c0f1428102222193397d51d2d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "caf55299106769ee6eb9c9d6ac204dc94cccf99c0f1428102222193397d51d2d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "caf55299106769ee6eb9c9d6ac204dc94cccf99c0f1428102222193397d51d2d"
    sha256 cellar: :any_skip_relocation, sonoma:        "917783ff23e2f294655d8e8e0350bec49612197a12a6c58d932cd4c02e3cca56"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e0cba841a9cc2a2701339c18632dff45a2ddd5cfa2c55e345d53512d8b3adcad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c27e1070bfea8b1d10d262007864eb32dad216b05f8dfe2f8318e866f6716254"
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
