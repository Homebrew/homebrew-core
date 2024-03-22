class Frps < Formula
  desc "Server app of fast reverse proxy to expose a local server to the internet"
  homepage "https://github.com/fatedier/frp"
  url "https://github.com/fatedier/frp.git",
      tag:      "v0.56.0",
      revision: "5a6d9f60c27acd10e438d7f724ad929703dccdc7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9c2e9b7442794481778ff26aead650364e8c4922501ee417e37dda4f7aa17734"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9c2e9b7442794481778ff26aead650364e8c4922501ee417e37dda4f7aa17734"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c2e9b7442794481778ff26aead650364e8c4922501ee417e37dda4f7aa17734"
    sha256 cellar: :any_skip_relocation, sonoma:         "6f5e4b3dca3e135b5d721a922671e12e0e7f41c069a59f36517d4cfc5c654e02"
    sha256 cellar: :any_skip_relocation, ventura:        "6f5e4b3dca3e135b5d721a922671e12e0e7f41c069a59f36517d4cfc5c654e02"
    sha256 cellar: :any_skip_relocation, monterey:       "6f5e4b3dca3e135b5d721a922671e12e0e7f41c069a59f36517d4cfc5c654e02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a8f4995fd993e5e30ce3fcbe69640ff0be97d1e3f7f868ea0c1e73a5cfed65f"
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
