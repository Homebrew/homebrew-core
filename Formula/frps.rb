class Frps < Formula
  desc "Server app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp.git",
      tag:      "v0.39.0",
      revision: "2dab5d0bca96cadcd3efa627d26ee419f322b64e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cc9c61563eb468a92a4101364b94178e0b12c12fe5a4baacaf361f11bbd0f82d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cc9c61563eb468a92a4101364b94178e0b12c12fe5a4baacaf361f11bbd0f82d"
    sha256 cellar: :any_skip_relocation, monterey:       "3afdb526a3e5d7861b0cbc0d2f1888bd5e439307fa7705ecacc0df8c31c78870"
    sha256 cellar: :any_skip_relocation, big_sur:        "3afdb526a3e5d7861b0cbc0d2f1888bd5e439307fa7705ecacc0df8c31c78870"
    sha256 cellar: :any_skip_relocation, catalina:       "3afdb526a3e5d7861b0cbc0d2f1888bd5e439307fa7705ecacc0df8c31c78870"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81faf20eaacd866edba45fcb54747fa9e36ff6576b7b7984f8cfbea1513a71ef"
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
