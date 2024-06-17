class Chronograf < Formula
  desc "Open source monitoring and visualization UI for the TICK stack"
  homepage "https://docs.influxdata.com/chronograf/latest/"
  url "https://github.com/influxdata/chronograf/archive/refs/tags/1.10.5.tar.gz"
  sha256 "bd887b98d6fb5f7ce22a443a7a56f6705ad5ba4ad7eb969c9a6d89e115b07541"
  license "AGPL-3.0-or-later"
  head "https://github.com/influxdata/chronograf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "479ff3daf9e0210d42afe5715221e08ef27fbc115061a7a76679a9e0d8032ea3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e7c68f9bd678c75268354f29fca7dd9bdb99eafb1fa30d5aabcf0124d57c6cc4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f879489d6e407bacb32ad21833e69d9a1ba3d9c3e91486a87f0bb4a4d5f238f9"
    sha256 cellar: :any_skip_relocation, sonoma:         "face2320a40e63960ec6961ad37b94e578a78c8eb1666958c7229537a7ad7dd0"
    sha256 cellar: :any_skip_relocation, ventura:        "595d2b0e4c40cd4e1551c5b59a4c49e63b7b812a5e31720a548960ac88392ff1"
    sha256 cellar: :any_skip_relocation, monterey:       "b511bbf276eeec195dd8004819008ef122e517b38818c6eb230d0f55d88b2cd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "29fb84d4eb87f377d640e5de2e57ffde59f03e20bc0b0b250371a79f45261f28"
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
