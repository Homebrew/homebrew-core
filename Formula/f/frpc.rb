class Frpc < Formula
  desc "Client app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp.git",
      tag:      "v0.58.1",
      revision: "e64969221784b97338e821f6f5606cfaa40177c5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b66cccb6a30e1398443dd5421b5d80348a09c69258ebb830ca05e4ec9b974eea"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b66cccb6a30e1398443dd5421b5d80348a09c69258ebb830ca05e4ec9b974eea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b66cccb6a30e1398443dd5421b5d80348a09c69258ebb830ca05e4ec9b974eea"
    sha256 cellar: :any_skip_relocation, sonoma:         "8b00f1d83fa7e9c486bc0a03c52f85a032326f1fa0d18a9db63f105571e71758"
    sha256 cellar: :any_skip_relocation, ventura:        "8b00f1d83fa7e9c486bc0a03c52f85a032326f1fa0d18a9db63f105571e71758"
    sha256 cellar: :any_skip_relocation, monterey:       "8b00f1d83fa7e9c486bc0a03c52f85a032326f1fa0d18a9db63f105571e71758"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6d14bf127a0e50120296fa58c6571ba958904c73ae084ff136fb14d18477dbb"
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
