class Chronograf < Formula
  desc "Open source monitoring and visualization UI for the TICK stack"
  homepage "https://docs.influxdata.com/chronograf/latest/"
  url "https://github.com/influxdata/chronograf/archive/refs/tags/1.10.4.tar.gz"
  sha256 "b08a9a0059699dde859096d67a111a2e61e4fb9617c00b9152a37e965745588c"
  license "AGPL-3.0-or-later"
  head "https://github.com/influxdata/chronograf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5e98b4fab26616b26e24b9809dab2714e0b18f223e784627a21f7caa9db54a2e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "31c70202b99f4a2627c267b69c5df07b4b18cd3749e1b95501034384fde87d73"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c893134651b584b7a932910b89080f7e2db3606099ee7fe052a2b06084993ea"
    sha256 cellar: :any_skip_relocation, sonoma:         "9e0967c7cd3444cd8e7ff843df5255f8601fe55443874e11cbdc0149377143d9"
    sha256 cellar: :any_skip_relocation, ventura:        "cbd94682e972cdabec060f9f176c36aa8577c353619de0d5f2e12ab89340e8dd"
    sha256 cellar: :any_skip_relocation, monterey:       "4f0bf7bcbb4e60ea95c4aa2ddf0eef0aede54d001eb81af85b3b6bbc6f637d97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24669c1b0c030a95fa33dd1cc2db387e81751cc53e3208180cfc60590efeffa1"
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
