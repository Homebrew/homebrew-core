class Chronograf < Formula
  desc "Open source monitoring and visualization UI for the TICK stack"
  homepage "https://docs.influxdata.com/chronograf/latest/"
  url "https://github.com/influxdata/chronograf/archive/refs/tags/1.10.6.tar.gz"
  sha256 "fdfa914ae75ed62f6ab9e2052df0463a10c0a8164a968bbd240dfaa9b4b4336b"
  license "AGPL-3.0-or-later"
  head "https://github.com/influxdata/chronograf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c6f0c50fbbcb105c16ab85f14c9617686184ea77ef865b3d9e70cb0cbf3b299"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "72264340eac06789de942e6e0cef807da0dc47960a74a86fdb0cb6df54f7ef55"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8b664526d0b3264296a448545be20bffcf55f6f881dba130dd4e4a668ffcc996"
    sha256 cellar: :any_skip_relocation, sonoma:        "71ae894712f61af67b7e6e621c64a381b47a699b08865a66e199392bd847a658"
    sha256 cellar: :any_skip_relocation, ventura:       "04c46f01b5e570eb2ca462d6d52e6ca675458e11664bbae49ea017452f8a0b7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ae34e06a0a406da8cadae54ef3d4ac06fda959916ea9511b08ab4cf6207ff45"
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
