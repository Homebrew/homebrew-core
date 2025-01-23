class Frps < Formula
  desc "Server app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp/archive/refs/tags/v0.61.1.tar.gz"
  sha256 "95c567188d5635a7ac8897a6f93ae0568d0ac4892581a96c89874a992dd6a73c"
  license "Apache-2.0"
  head "https://github.com/fatedier/frp.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa2b289fd25fd83eaa9aebb2b0d6f62d70b9c7bd7853cb6134aaa3c9a388bd62"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa2b289fd25fd83eaa9aebb2b0d6f62d70b9c7bd7853cb6134aaa3c9a388bd62"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "aa2b289fd25fd83eaa9aebb2b0d6f62d70b9c7bd7853cb6134aaa3c9a388bd62"
    sha256 cellar: :any_skip_relocation, sonoma:        "c3656a73ac6e6a6c70f413879e9e3c0648e96b1c4757951a4a18ca29998c87b8"
    sha256 cellar: :any_skip_relocation, ventura:       "c3656a73ac6e6a6c70f413879e9e3c0648e96b1c4757951a4a18ca29998c87b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9974987c290ae8eee6cd54e5a650ebfcfbb27cc87b51372480873edb181ecbbf"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-tags=frps", "./cmd/frps"

    (etc/"frp").install "conf/frps.toml"
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
