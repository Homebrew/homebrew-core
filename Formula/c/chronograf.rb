class Chronograf < Formula
  desc "Open source monitoring and visualization UI for the TICK stack"
  homepage "https://docs.influxdata.com/chronograf/latest/"
  url "https://github.com/influxdata/chronograf/archive/refs/tags/1.10.8.tar.gz"
  sha256 "6bf4e5176d4b0f039c078c5c71a80a460813f6f40028c76828d35392cb4c2d02"
  license "AGPL-3.0-or-later"
  head "https://github.com/influxdata/chronograf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b173f2fbad114a2efe46f6f8a4f210b21b4c90166273c8cd8b57c43801e131f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2aa264c77b7a1580f44f13fe423a5057a8cca42ed6c1681e65dd99ac673365f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "338e3d49164c033aff7aaacb29efa9f7c138f169c13bd7e7cc9c6ced32e8f986"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ba7d5a5e977bc21bd5b38c992c9e662971edef12bfffdb564fe0aae14f85a325"
    sha256 cellar: :any_skip_relocation, sonoma:        "2f4bc398a63f400a368e0ac15b5c76695fa4931d1a12cfeebdefeb8f2099ab41"
    sha256 cellar: :any_skip_relocation, ventura:       "bf4bceda8fe5e269e3fb1e431afa340871ea7fbb6508fbef4e633b7cbf191231"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dbb34f30e0bfcd31f6a12a844471439e68c0fa470f8d14eb70f01b0172e19944"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build
  depends_on "influxdb"
  depends_on "kapacitor"

  def install
    # Fix build with latest node: https://github.com/influxdata/chronograf/issues/6040
    system "yarn", "upgrade", "nan@^2.13.2", "--dev", "--ignore-scripts"
    ENV.deparallelize
    system "make"
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
      exec bin/"chronograf", "--port=#{port}"
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
