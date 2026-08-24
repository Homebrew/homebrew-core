class Pinot < Formula
  desc "Realtime distributed OLAP datastore"
  homepage "https://pinot.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=pinot/apache-pinot-1.5.1/apache-pinot-1.5.1-bin.tar.gz"
  mirror "https://archive.apache.org/dist/pinot/apache-pinot-1.5.1/apache-pinot-1.5.1-bin.tar.gz"
  sha256 "805b7525c1c87019211f416c0201e662da8e2c0a57549d624eaf7dcfdc8b14f3"
  license "Apache-2.0"
  head "https://github.com/apache/pinot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "dd2e6d2ba8e8bb950465b2e2708ba3e1108788c4f8405615a98a523c709368c2"
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

    zkpid = spawn "#{opt_bin}/pinot-admin", "StartZookeeper", "-zkPort", zkport.to_s
    sleep 10
    sleep 30 if Hardware::CPU.intel?

    controller_pid = spawn "#{opt_bin}/pinot-admin", "StartController",
                           "-zkAddress", "localhost:#{zkport}",
                           "-controllerPort", controller_port.to_s
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
