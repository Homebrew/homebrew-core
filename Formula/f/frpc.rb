class Frpc < Formula
  desc "Client app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp/archive/refs/tags/v0.69.1.tar.gz"
  sha256 "79a62c1071ddb947e95146ad7b1cb8b25f182fed548a4a8a68d5fca06b37502c"
  license "Apache-2.0"
  head "https://github.com/fatedier/frp.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a8064f4bcb1eb546fad61c08d6f1a5e7ed8ede0e60fd6cee068abd9c0bd81281"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a8064f4bcb1eb546fad61c08d6f1a5e7ed8ede0e60fd6cee068abd9c0bd81281"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a8064f4bcb1eb546fad61c08d6f1a5e7ed8ede0e60fd6cee068abd9c0bd81281"
    sha256 cellar: :any_skip_relocation, sonoma:        "66db0f1d8faf08cf0e7f546b0942d7ffe85a0ddcb6c83ca86b061fdea69ccbc7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "db0262c1196eaadbd820771a1d4b933e425f35243db0bade7d334e9ada65523a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13d4d04d42a1f97e0fc504a8e7fc0eba35c66a4a3dabcd5f404287ace60bc236"
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
