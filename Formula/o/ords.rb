class Ords < Formula
  desc "Oracle REST Data Services for Oracle Database"
  homepage "https://www.oracle.com/database/sqldeveloper/technologies/db-actions/download/"
  url "https://download.oracle.com/otn_software/java/ords/ords-25.2.3.224.1517.zip"
  sha256 "3e30c548bdbe1d272ca755ec91726e6c0c79fd561ebef4eb58908a56e6c9373f"
  license :cannot_represent

  livecheck do
    url :homepage
    regex(/href=.*ords[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  def install
    rm "bin/ords.exe"
    bin.install "bin/ords"
    bin.install "bin/ords-metrics"
    prefix.install Dir["*"]
  end

  def caveats
    <<~EOS
      ORDS requires Java 17 - 21.
      Make sure you set you PATH to include #{HOMEBREW_PREFIX}/bin
      License information: https://www.oracle.com/downloads/licenses/oracle-free-license.html
    EOS
  end

  test do
    begin
      pid = fork do
        $stdout.reopen("ords_serve_test.log", "w")
        $stderr.reopen("ords_serve_test.log", "a")
        exec "ords", "serve"
      end
      sleep 5
      assert pid.positive?, "ords serve process should be running"
    ensure
      if pid
        Process.kill("TERM", pid)
        Process.wait(pid)
      end
    end
    assert_match "INFO", shell_output("cat ords_serve_test.log")
  end
end
