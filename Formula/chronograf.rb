require "language/node"

class Chronograf < Formula
  desc "Open source monitoring and visualization UI for the TICK stack"
  homepage "https://docs.influxdata.com/chronograf/latest/"
  url "https://github.com/influxdata/chronograf/archive/1.9.4.tar.gz"
  sha256 "ff294f25a9de57140024b9953992c1a4d79ec88167ad28435645d888a0096c27"
  license "AGPL-3.0-or-later"
  head "https://github.com/influxdata/chronograf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ab69cb68e4b4030eb2e745f61ea7e12395acfa022972f47d703b9b7be57d3bd6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "88dbfa8ec052d2e709738815fde6071ecca9636c2f88ff28aeebd1ffa494fa1f"
    sha256 cellar: :any_skip_relocation, monterey:       "72874b39bf45019aa2dc5978d1547ebb5f68e95a39bcf33ecd0baef1974c901f"
    sha256 cellar: :any_skip_relocation, big_sur:        "f8786d16d900600eddd3642e91193b7abb8fc0437885e489e645368c6b93598f"
    sha256 cellar: :any_skip_relocation, catalina:       "7ae8967d39df93b8317ae898a2c94a6fcd5047ddfbadd6be60cab61865eaa906"
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
