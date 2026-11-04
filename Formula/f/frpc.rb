class Frpc < Formula
  desc "Client app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp/archive/refs/tags/v0.72.0.tar.gz"
  sha256 "20e2249c2b17cb7624317b0a9a0baed06c80c547d27568d18a32c78e46d79230"
  license "Apache-2.0"
  compatibility_version 1
  head "https://github.com/fatedier/frp.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "271bfdf210af83e526f290a05e98d643a2fc4747ffadd1b76b8a28b5a9faeb07"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "271bfdf210af83e526f290a05e98d643a2fc4747ffadd1b76b8a28b5a9faeb07"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "271bfdf210af83e526f290a05e98d643a2fc4747ffadd1b76b8a28b5a9faeb07"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9eb251e0cbd49efa9acc03a49d8818c571074b6b05151f6e3cb161e8456694b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "0907d28beb8fffab577e20f5d1c86f3984165a8a0388504e915ed163ca8e33ca"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
    cd "web/frpc" do
      system "npm", "install", *std_npm_args(prefix: false)
    end
  end

  def install
    cd "web/frpc" do
      system "npm", "--offline", "run", "build-only"
    end

    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(tags: "frpc"), "./cmd/frpc"
    (etc/"frp").install "conf/frpc.toml"

    generate_completions_from_executable(bin/"frpc", "completion")
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
