class Frpc < Formula
  desc "Client app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp.git",
      tag:      "v0.55.1",
      revision: "a5b7abfc8b24491a60fb72369b9e980791f63dd7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4e394a1162a10c36ee0d9b965038ad59e834dc88334058abf77d1e65802f65d9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4e394a1162a10c36ee0d9b965038ad59e834dc88334058abf77d1e65802f65d9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e394a1162a10c36ee0d9b965038ad59e834dc88334058abf77d1e65802f65d9"
    sha256 cellar: :any_skip_relocation, sonoma:         "aa6f8c564d985da06ca326cdd3e618bddddc4e1a1cc7a66b8888ec25b2612f55"
    sha256 cellar: :any_skip_relocation, ventura:        "aa6f8c564d985da06ca326cdd3e618bddddc4e1a1cc7a66b8888ec25b2612f55"
    sha256 cellar: :any_skip_relocation, monterey:       "aa6f8c564d985da06ca326cdd3e618bddddc4e1a1cc7a66b8888ec25b2612f55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ff299e7f55c121991801a8e91370aec4512f0a5ccb4c542a009bb2c2fba5090"
  end

  depends_on "go" => :build

  def install
    (buildpath/"bin").mkpath
    (etc/"frp").mkpath

    system "make", "frpc"
    bin.install "bin/frpc"
    etc.install "conf/frpc.toml" => "frp/frpc.toml"
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
