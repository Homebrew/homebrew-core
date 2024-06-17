class Frps < Formula
  desc "Server app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp.git",
      tag:      "v0.58.1",
      revision: "e64969221784b97338e821f6f5606cfaa40177c5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d60b7f1692b7ae1806a883f8309acdbdc4c95cd5f450982e0ae76baec11e00f1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d60b7f1692b7ae1806a883f8309acdbdc4c95cd5f450982e0ae76baec11e00f1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d60b7f1692b7ae1806a883f8309acdbdc4c95cd5f450982e0ae76baec11e00f1"
    sha256 cellar: :any_skip_relocation, sonoma:         "0f2979c08128d1649788a6d31b874262ff3618f0d813350f304db2fc4bb742fe"
    sha256 cellar: :any_skip_relocation, ventura:        "0f2979c08128d1649788a6d31b874262ff3618f0d813350f304db2fc4bb742fe"
    sha256 cellar: :any_skip_relocation, monterey:       "0f2979c08128d1649788a6d31b874262ff3618f0d813350f304db2fc4bb742fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db51c57eca0ae42cf985063ebbd51d6d9078ca5519ccb99f23c79049b610d868"
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
