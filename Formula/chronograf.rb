require "language/node"

class Chronograf < Formula
  desc "Open source monitoring and visualization UI for the TICK stack"
  homepage "https://docs.influxdata.com/chronograf/latest/"
  url "https://github.com/influxdata/chronograf/archive/1.9.3.tar.gz"
  sha256 "10db16bb6959356c4fabe6229a500d3183436f401a3c15a5377bc7434fe489d3"
  license "AGPL-3.0-or-later"
  head "https://github.com/influxdata/chronograf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c7604bdab8c7c4f33b4c967b1b49c00e633d42b92d09766edc761fb7025fcd72"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dfbd8e5594ee870bbde6d5240316e96ce834a6b9baaf57bebe97a6d3f5e78a4e"
    sha256 cellar: :any_skip_relocation, monterey:       "8911490bf5866e4abda1cca48f93d56421ffdd71efdd5b7e161223de6d0cbec4"
    sha256 cellar: :any_skip_relocation, big_sur:        "4d044fbeca83317dbe4ef52f37d2bf949b0a16fe65cec1b512c5bcc14c21c5df"
    sha256 cellar: :any_skip_relocation, catalina:       "5b6b0687b16f079dd3e7934e3e120bd57522f674b579fe34d630463a6d01773f"
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
