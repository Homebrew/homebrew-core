class Pinot < Formula
  desc "Realtime distributed OLAP datastore"
  homepage "https://pinot.apache.org/"
  url "https://downloads.apache.org/pinot/apache-pinot-0.9.3/apache-pinot-0.9.3-bin.tar.gz"
  sha256 "c253eb9ce93f11f368498229282846588f478cb6e0359e24167b13e97417c025"
  license "Apache-2.0"
  head "https://github.com/apache/pinot.git", branch: "master"

  depends_on "openjdk"

  def install
    (var/"lib/pinot/data").mkpath

    libexec.install "lib"
    libexec.install "plugins"

    prefix.install "bin"
    bin.env_script_all_files(libexec/"bin", Language::Java.java_home_env)
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
    assert_match("StartController", shell_output("#{bin}/pinot-admin -h 2>&1"))
  end
end
