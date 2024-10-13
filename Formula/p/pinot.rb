class Pinot < Formula
  desc "Realtime distributed OLAP datastore"
  homepage "https://pinot.apache.org/"
  url "https://downloads.apache.org/pinot/apache-pinot-1.2.0/apache-pinot-1.2.0-bin.tar.gz"
  sha256 "349120b114e5bda700b5f6527c5a22b016f0fc486ab28560999693b4fab8c822"
  license "Apache-2.0"
  head "https://github.com/apache/pinot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4a8d159e06c7ca4d5358e2254e3803f5ced134b852657a018eb27b6ff910b8e4"
  end

  depends_on "openjdk@11"

  def install
    (var/"lib/pinot/data").mkpath

    libexec.install "lib"
    libexec.install "plugins"

    prefix.install "bin"
    bin.env_script_all_files(libexec/"bin", Language::Java.java_home_env("11"))
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

    controller_pid = fork do
      exec "#{opt_bin}/pinot-admin",
        "StartController",
        "-zkAddress",
        "localhost:#{zkport}",
        "-controllerPort",
        controller_port.to_s
    end

    sleep 40

    assert_match("HTTP/1.1 200 OK", shell_output("curl -i http://localhost:#{controller_port} 2>&1"))
  ensure
    Process.kill "TERM", controller_pid
    Process.wait controller_pid
    Process.kill "TERM", zkpid
    Process.wait zkpid
  end
end
