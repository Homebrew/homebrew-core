class Frpc < Formula
  desc "Client app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp/archive/refs/tags/v0.71.1.tar.gz"
  sha256 "079f5fdebfbf8b8fa42c8b03245d169a7b5298697d754d7345ea25f09e496722"
  license "Apache-2.0"
  head "https://github.com/fatedier/frp.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "58a89102a5e6dc2dfab37388df05b66060df446e2b34d77cfd031703fee53a28"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "58a89102a5e6dc2dfab37388df05b66060df446e2b34d77cfd031703fee53a28"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "58a89102a5e6dc2dfab37388df05b66060df446e2b34d77cfd031703fee53a28"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c387abbd6763519ebda3c0a543a7b0178b509c4d09cd65a9559c17fba27881a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "c2f6661f5734d338d7ae078e582ca9c5328e670f5d0078459c73dee8f097a833"
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
