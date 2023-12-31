class Frps < Formula
  desc "Server app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp.git",
      tag:      "v0.53.2",
      revision: "d505ecb473751e24cdfd2df7676beb5e54eff676"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "be1d77b0f567e782024d662e753c2be8004f231c1924424854bfe4179af4ac24"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "be1d77b0f567e782024d662e753c2be8004f231c1924424854bfe4179af4ac24"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be1d77b0f567e782024d662e753c2be8004f231c1924424854bfe4179af4ac24"
    sha256 cellar: :any_skip_relocation, sonoma:         "952d77ba6e2919dca68eb1ad9975b35bb83a492e421a81383d7f7b1c7aba5df5"
    sha256 cellar: :any_skip_relocation, ventura:        "952d77ba6e2919dca68eb1ad9975b35bb83a492e421a81383d7f7b1c7aba5df5"
    sha256 cellar: :any_skip_relocation, monterey:       "952d77ba6e2919dca68eb1ad9975b35bb83a492e421a81383d7f7b1c7aba5df5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "beccb573e57ba60900e1c4fb379fd81f8d68ddb8c1983993d2590595042ce875"
  end

  depends_on "go" => :build

  def install
    (buildpath/"bin").mkpath
    (etc/"frp").mkpath

    system "make", "frps"
    bin.install "bin/frps"
    etc.install "conf/frps.toml" => "frp/frps.toml"
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
