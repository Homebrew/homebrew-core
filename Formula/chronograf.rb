require "language/node"

class Chronograf < Formula
  desc "Open source monitoring and visualization UI for the TICK stack"
  homepage "https://docs.influxdata.com/chronograf/latest/"
  url "https://github.com/influxdata/chronograf/archive/1.9.1.tar.gz"
  sha256 "df5600b2bd0b5ed0d3a3c548e5d72038b62fdda1501ad616eb1c1d82b054793a"
  license "AGPL-3.0-or-later"
  head "https://github.com/influxdata/chronograf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "035e1ec95c64d5db5d2dc3305ac3f631d50b55f7d402a2ed0a74aa981f3cd9e7"
    sha256 cellar: :any_skip_relocation, big_sur:       "36287a0454a409f11fcf156310fd5e835818266a8e25121299cc0234afc85f88"
    sha256 cellar: :any_skip_relocation, catalina:      "3675d74285d934ae45bd86c69d91807accc50d4f31a5e3dd2963097bef49874a"
    sha256 cellar: :any_skip_relocation, mojave:        "5be98ea883d9df39a4082192cf41044886bf8dfc7c2ea2c82c5f9392df790b15"
  end

  depends_on "go" => :build
  depends_on "go-bindata" => :build
  # Switch to `node` when chronograf updates dependency node-sass>=6.0.0
  depends_on "node@14" => :build
  depends_on "yarn" => :build
  depends_on "influxdb"
  depends_on "kapacitor"

  def install
    Language::Node.setup_npm_environment

    system "make", "dep"
    system "make", ".jssrc"
    system "make", "chronograf"
    bin.install "chronograf"
  end

  service do
    run opt_bin/"chronograf"
    keep_alive true
    error_log_path var/"log/chronograf.log"
    log_path var/"log/chronograf.log"
    working_dir var
  end

  test do
    port = free_port
    pid = fork do
      exec "#{bin}/chronograf --port=#{port}"
    end
    sleep 10
    output = shell_output("curl -s 0.0.0.0:#{port}/chronograf/v1/")
    sleep 1
    assert_match %r{/chronograf/v1/layouts}, output
  ensure
    Process.kill("SIGTERM", pid)
    Process.wait(pid)
  end
end
