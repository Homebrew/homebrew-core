class Frpc < Formula
  desc "Client app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp/archive/refs/tags/v0.67.0.tar.gz"
  sha256 "18d0a35b965fab7e348aafc7b587847dd04ef2ef84822ed8fd5b9fe46b7ff6d7"
  license "Apache-2.0"
  head "https://github.com/fatedier/frp.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7c72c0a6ccadeeefdd80d8af3b66d59bd7d3dfaeb59be326c388cac52991030f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c72c0a6ccadeeefdd80d8af3b66d59bd7d3dfaeb59be326c388cac52991030f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c72c0a6ccadeeefdd80d8af3b66d59bd7d3dfaeb59be326c388cac52991030f"
    sha256 cellar: :any_skip_relocation, sonoma:        "0fdc17eb89afa9728aee5943088f3201af2914c95e1c552c96c13b3a66181f66"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4f0857fc63eef4ecaaaa9614c3819e526d79ab27652d932ddcf97be375b7f87a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5b2e8d766c7a6bd39067c345a462dc75339e7f3fb020e90d709637936e780f4"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  def install
    cd "web/frpc" do
      system "npm", "install", *std_npm_args(prefix: false)
      system "npm", "run", "build"
    end

    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags: "-s -w", tags: "frpc"), "./cmd/frpc"
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
