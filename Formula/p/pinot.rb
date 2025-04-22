class Pinot < Formula
  desc "Realtime distributed OLAP datastore"
  homepage "https://pinot.apache.org/"
  url "https://downloads.apache.org/pinot/apache-pinot-1.3.0/apache-pinot-1.3.0-bin.tar.gz"
  sha256 "9cdc4423187c44569b8c6dd376d0162cc05339f56498a7f3a594303f17e44af0"
  license "Apache-2.0"
  head "https://github.com/apache/pinot.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "dd4c35dab1e00cb76d570424d53e76cb020343111b7be8fc3ed73dee0c6dcc90"
  end

  depends_on "openjdk@21"

  def install
    java_env = Language::Java.java_home_env("21").merge(PATH: "${JAVA_HOME}/bin:${PATH}")
    (var/"lib/pinot/data").mkpath

    libexec.install "lib"
    libexec.install "plugins"

    prefix.install "bin"
    bin.env_script_all_files(libexec/"bin", java_env)
    bin.glob("*.sh").each { |f| mv f, bin/f.basename(".sh") }
  end

  service do
    run [opt_bin/"pinot-admin", "QuickStart", "-type", "BATCH", "-dataDir", var/"lib/pinot/data"]
    keep_alive true
    working_dir var/"lib/pinot"
    log_path var/"log/pinot/pinot_output.log"
    error_log_path var/"log/pinot/pinot_output.log"
  end

  test do
    zkport = free_port
    controller_port = free_port

    zkpid = fork do
      exec "#{opt_bin}/pinot-admin",
        "StartZookeeper",
        "-zkPort",
        zkport.to_s
    end

    sleep 10
    sleep 30 if Hardware::CPU.intel?

    controller_pid = fork do
      exec "#{opt_bin}/pinot-admin",
        "StartController",
        "-zkAddress",
        "localhost:#{zkport}",
        "-controllerPort",
        controller_port.to_s
    end

    sleep 30
    sleep 30 if Hardware::CPU.intel?

    assert_match("HTTP/1.1 200 OK", shell_output("curl -i http://localhost:#{controller_port} 2>&1"))
  ensure
    Process.kill "TERM", controller_pid
    Process.wait controller_pid
    Process.kill "TERM", zkpid
    Process.wait zkpid
  end
end
