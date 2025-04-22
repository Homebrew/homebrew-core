class Chronograf < Formula
  desc "Open source monitoring and visualization UI for the TICK stack"
  homepage "https://docs.influxdata.com/chronograf/latest/"
  url "https://github.com/influxdata/chronograf/archive/refs/tags/1.10.7.tar.gz"
  sha256 "1b88a6a1d7eb36d8b6b5ac1506d9647c978bc9bd466cba37c45bed2d86bd20e5"
  license "AGPL-3.0-or-later"
  head "https://github.com/influxdata/chronograf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51f35a21cae93b46a86a08c5c5332b89eb7404cd6787795c8a8f1692774d3476"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e2fd137ebfb0cce98c94a3d37b5d783a280845052c8c54f75c422e14c5f0674"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e8cc046d7259a5ee5e1323781b3f0bec179880e4c4212bae48deb24111eae83f"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a66a4feaee1f1fc2fffc98f9d041158db45707c63c17555c18ddb04f8ff9e48"
    sha256 cellar: :any_skip_relocation, ventura:       "c33e782ad82a70043529faee89384568ce7e29a1361eadd5c0ebb59bc2c686c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e759876413c0d7824dce27426b7dc96ccf9efd097872569210da0dcb8c8ff58"
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
