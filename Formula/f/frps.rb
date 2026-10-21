class Frps < Formula
  desc "Server app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp/archive/refs/tags/v0.71.1.tar.gz"
  sha256 "079f5fdebfbf8b8fa42c8b03245d169a7b5298697d754d7345ea25f09e496722"
  license "Apache-2.0"
  head "https://github.com/fatedier/frp.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "25858c731c18f7646b5890127c276e5d35d92c81589bdae4638c6beb2b0150e5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "25858c731c18f7646b5890127c276e5d35d92c81589bdae4638c6beb2b0150e5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "25858c731c18f7646b5890127c276e5d35d92c81589bdae4638c6beb2b0150e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5a49628d69b843902b67426f1f0013e32554fbabf10836ebba13b708dfadff0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "41a2be81644958195fcd1d0d160336884e36e120879a27e3990c09cb7b7f8f3c"
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
