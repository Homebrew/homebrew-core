class Chronograf < Formula
  desc "Open source monitoring and visualization UI for the TICK stack"
  homepage "https://docs.influxdata.com/chronograf/latest/"
  url "https://github.com/influxdata/chronograf/archive/1.10.1.tar.gz"
  sha256 "d2fb4759f4f94d81dcde5c50fece46febd7f610ee7d9373fd000d7a9986a52d8"
  license "AGPL-3.0-or-later"
  head "https://github.com/influxdata/chronograf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "602fe0232ff480acb80ff6cb3b31c8dbaf3bb0ce1c47402f32487b00bcd1a268"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d26103a39387cd6d8a5274337dfa457e00c8530b70ba7ac5517537a09e1862b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d6df8eed31030398474b427f569afb3ff0360d6ba9180c4e42db83ed750b37fa"
    sha256 cellar: :any_skip_relocation, ventura:        "4aa35bb186c11b248680c1a339b9275941233de29b1fb44e469c7a558c679693"
    sha256 cellar: :any_skip_relocation, monterey:       "d5309c8de2da2b81da5eaa363b282e7baee913030c38e9e19defe80cd7d6ca5a"
    sha256 cellar: :any_skip_relocation, big_sur:        "fd509ab2599058d4f1eb3e7d2564af70e6b862240d7e07ea770e389de52d3ca4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c07cf1484bb28d5abe7461afb21ffd54b3bbcb1dc6afa4afff288ca68026666"
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
