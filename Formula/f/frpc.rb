class Frpc < Formula
  desc "Client app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp/archive/refs/tags/v0.61.1.tar.gz"
  sha256 "95c567188d5635a7ac8897a6f93ae0568d0ac4892581a96c89874a992dd6a73c"
  license "Apache-2.0"
  head "https://github.com/fatedier/frp.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "15f4bee00e11455b79bafed49fe4add3577ac9d7bb33ff4e363ee7ab5f11a0ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "15f4bee00e11455b79bafed49fe4add3577ac9d7bb33ff4e363ee7ab5f11a0ac"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "15f4bee00e11455b79bafed49fe4add3577ac9d7bb33ff4e363ee7ab5f11a0ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba1df73f8be1274af6316e810541b3bf9c8daa35d082dc47514e8191826b8273"
    sha256 cellar: :any_skip_relocation, ventura:       "ba1df73f8be1274af6316e810541b3bf9c8daa35d082dc47514e8191826b8273"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd36f31abb88e23d44410e851fdee362224e877c5a1998ad72085c88b51b9f26"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-tags=frpc", "./cmd/frpc"
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
