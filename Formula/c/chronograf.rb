class Chronograf < Formula
  desc "Open source monitoring and visualization UI for the TICK stack"
  homepage "https://docs.influxdata.com/chronograf/latest/"
  url "https://github.com/influxdata/chronograf/archive/refs/tags/1.10.3.tar.gz"
  sha256 "df90d3740f0012884dec3ee6485b14dc5afa62203ca2d611116af2c814621ef7"
  license "AGPL-3.0-or-later"
  head "https://github.com/influxdata/chronograf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "57f2f887d22988e5ea7cd36ff4c88cb705a8e02b4f4dde355f2b36a8a456c97d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0579baf1d2eb36ee8a14daaacfd76bec6e95e1cd1e31564816eef3a8e0cf8aa4"
    sha256 cellar: :any_skip_relocation, ventura:        "fa6b69b55e5e21ef46572c4bc24683f0966cd7afb0628d07b9ffee62803b2d31"
    sha256 cellar: :any_skip_relocation, monterey:       "5639a8a4f20d846c826ce0642ef986df262b4b5ed89bb8199f0ca7c9d6d0414d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6fa5a13c0a1406a73e317b3945bc7be3375e1e372cd3f37e4878bd37e21851df"
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
