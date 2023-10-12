class Frps < Formula
  desc "Server app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp.git",
      tag:      "v0.52.1",
      revision: "31fa3f021ad290df8b2ef4e3f6eecfc49b3cc69f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fceb8fe3f38c1394f442ac310e336018b1676a7a2b670dd0b88bf2cebbe8c04f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fceb8fe3f38c1394f442ac310e336018b1676a7a2b670dd0b88bf2cebbe8c04f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fceb8fe3f38c1394f442ac310e336018b1676a7a2b670dd0b88bf2cebbe8c04f"
    sha256 cellar: :any_skip_relocation, sonoma:         "01cd4e2cc89879de56f280db7577437202dfa7afa73cf210765b0afdd9cf35f4"
    sha256 cellar: :any_skip_relocation, ventura:        "01cd4e2cc89879de56f280db7577437202dfa7afa73cf210765b0afdd9cf35f4"
    sha256 cellar: :any_skip_relocation, monterey:       "01cd4e2cc89879de56f280db7577437202dfa7afa73cf210765b0afdd9cf35f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea0117f2d3785042ea6980f40d46cbb9bf83fac66b722e412a0a1508667b85e8"
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
