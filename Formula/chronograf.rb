require "language/node"

class Chronograf < Formula
  desc "Open source monitoring and visualization UI for the TICK stack"
  homepage "https://docs.influxdata.com/chronograf/latest/"
  url "https://github.com/influxdata/chronograf/archive/1.9.0.tar.gz"
  sha256 "d372ed570ffca770395ec2f8b3cf3da5c493462b3f9a9a23431bce48fa58db12"
  license "AGPL-3.0-or-later"
  head "https://github.com/influxdata/chronograf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a3ca0abd746047054e2fa1e16af01c66959d5016a0e53378f06d5e3abeefe6df"
    sha256 cellar: :any_skip_relocation, big_sur:       "cce9f41de6c70595ab6784f274f66ceddbd06199660c43a45ce87c88bf137cce"
    sha256 cellar: :any_skip_relocation, catalina:      "eea319beb941aebc561e2620daa487cc1dab344917b0eaacb13abae53ef73f64"
    sha256 cellar: :any_skip_relocation, mojave:        "bf63451f3ee0f4dc13c324e2611d63b31943a1e4b305ed4e29fcbe3edf0dae6b"
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
