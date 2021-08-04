class Frps < Formula
  desc "Server app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp.git",
      tag:      "v0.37.1",
      revision: "997d406ec25832e7d16f140d110e4016f908d8cf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "236a4b01aaaeb4e9fb088a23153b49cc14c25b5fc29e95f9354875e5c95d933a"
    sha256 cellar: :any_skip_relocation, big_sur:       "0f0aa7c413cce11341f70b0bb9c701ad22403251b12d1a1c329fc03141601d00"
    sha256 cellar: :any_skip_relocation, catalina:      "0f0aa7c413cce11341f70b0bb9c701ad22403251b12d1a1c329fc03141601d00"
    sha256 cellar: :any_skip_relocation, mojave:        "0f0aa7c413cce11341f70b0bb9c701ad22403251b12d1a1c329fc03141601d00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82dee9b33daa854caad5a9171f0e8e80511060e679daf74d4e872233f0768eef"
  end

  depends_on "go" => :build

  def install
    (buildpath/"bin").mkpath
    (etc/"frp").mkpath

    system "make", "frps"
    bin.install "bin/frps"
    etc.install "conf/frps.ini" => "frp/frps.ini"
    etc.install "conf/frps_full.ini" => "frp/frps_full.ini"
  end

  service do
    run [opt_bin/"frps", "-c", etc/"frp/frps.ini"]
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
