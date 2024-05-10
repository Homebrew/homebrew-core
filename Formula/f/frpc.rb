class Frpc < Formula
  desc "Client app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp.git",
      tag:      "v0.58.0",
      revision: "4e8e9e1decf37294cb2ab576158b5ecd4ffdbbf1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c1f2e14f19428518ca2eedf1a64c94abbfbae4ce99892b76acde70c36d351eee"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c1f2e14f19428518ca2eedf1a64c94abbfbae4ce99892b76acde70c36d351eee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c1f2e14f19428518ca2eedf1a64c94abbfbae4ce99892b76acde70c36d351eee"
    sha256 cellar: :any_skip_relocation, sonoma:         "238ef8d51ec4576b3b5163adc8b88cc56c086a186c01a49cda13f3c37e2d63f4"
    sha256 cellar: :any_skip_relocation, ventura:        "238ef8d51ec4576b3b5163adc8b88cc56c086a186c01a49cda13f3c37e2d63f4"
    sha256 cellar: :any_skip_relocation, monterey:       "238ef8d51ec4576b3b5163adc8b88cc56c086a186c01a49cda13f3c37e2d63f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d55e2e58258f1e5ffafa6f875e43cfc1d6cfe7da0288ce0103be0c335eb5112"
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
