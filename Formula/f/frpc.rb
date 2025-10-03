class Frpc < Formula
  desc "Client app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp/archive/refs/tags/v0.65.0.tar.gz"
  sha256 "bbec0d1855e66c96e3a79ff97b8c74d9b1b45ec560aa7132550254d48321f7de"
  license "Apache-2.0"
  head "https://github.com/fatedier/frp.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "94a3c2357986868f9b6554df6604003a639e60ce81e0dac0c60dfac7bb62d1a4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94a3c2357986868f9b6554df6604003a639e60ce81e0dac0c60dfac7bb62d1a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "94a3c2357986868f9b6554df6604003a639e60ce81e0dac0c60dfac7bb62d1a4"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d76a295110931d2192de6840348e0295b54a533b4096a73bfd71a7460d3246a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6da3475a814705782c2d31e229da8a75e584fe7b7f2cd00b0c6a2305b830cc56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e84f3e79d22f527a34ed7cecf0e98732785f9484d83c4721d8bb5dbce9c0430e"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags: "-s -w", tags: "frpc"), "./cmd/frpc"
    (etc/"frp").install "conf/frpc.toml"
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
