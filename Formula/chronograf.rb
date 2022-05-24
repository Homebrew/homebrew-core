require "language/node"

class Chronograf < Formula
  desc "Open source monitoring and visualization UI for the TICK stack"
  homepage "https://docs.influxdata.com/chronograf/latest/"
  url "https://github.com/influxdata/chronograf/archive/1.9.4.tar.gz"
  sha256 "ff294f25a9de57140024b9953992c1a4d79ec88167ad28435645d888a0096c27"
  license "AGPL-3.0-or-later"
  head "https://github.com/influxdata/chronograf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3ac8da143b92111d61c6911950351cea601a47a31966f68b374c208e3bf64314"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "49f3702369d67cb88f10c0f8929eeec8395e08aecf72c5b34fd3b6a3a7895e5e"
    sha256 cellar: :any_skip_relocation, monterey:       "f7458350c65b537d1fbac3216f0b10c02b8fc79ca584907c375a8346ad78b955"
    sha256 cellar: :any_skip_relocation, big_sur:        "ce89af5bfe0791d75fbdd44d9bf89f69a812848426c3163fa64e7dee331b6257"
    sha256 cellar: :any_skip_relocation, catalina:       "b2f8e625b097c6e78f52d70ab34f1c9c3c30cbaa5ad2e714d58378a13aa1d438"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f88324849ad91907bca05bb10d59eb708d4dcfa04bd8dce274df5fbe6e63b4cd"
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
