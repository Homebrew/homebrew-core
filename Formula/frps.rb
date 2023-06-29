class Frps < Formula
  desc "Server app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp.git",
      tag:      "v0.50.0",
      revision: "4fd800bc48708843e32962c9ce23df6f971fdc99"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "35d304bbb8b3609079cfeea81ea6f3da67b5a4891922bf60618aee4b57f4565f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "35d304bbb8b3609079cfeea81ea6f3da67b5a4891922bf60618aee4b57f4565f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "35d304bbb8b3609079cfeea81ea6f3da67b5a4891922bf60618aee4b57f4565f"
    sha256 cellar: :any_skip_relocation, ventura:        "d273903de7cf9235d63aea3c58119f06a1ae22f0a5f221aef382ff393bd5f994"
    sha256 cellar: :any_skip_relocation, monterey:       "d273903de7cf9235d63aea3c58119f06a1ae22f0a5f221aef382ff393bd5f994"
    sha256 cellar: :any_skip_relocation, big_sur:        "d273903de7cf9235d63aea3c58119f06a1ae22f0a5f221aef382ff393bd5f994"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ead977310b5aef1761345864113e919afe39d8b3235509ba622a4c5e22fe8d8"
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
