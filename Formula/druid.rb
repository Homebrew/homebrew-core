class Druid < Formula
  desc "High-performance, column-oriented, distributed data store"
  homepage "http://druid.io"
  url "http://static.druid.io/artifacts/releases/druid-0.9.2-bin.tar.gz"
  sha256 "10cb45d36c72ba4e4b7029c35bdfae0974b7950241ab06acaa8f8e284d1a989f"

  bottle :unneeded

  depends_on "zookeeper"
  depends_on :java => "1.8+"

  def install
    libexec.install Dir["*"]
    cd libexec do
      system "bin/init"
    end

    (bin/"druid").write <<-EOS.undent
      #!/bin/bash

      trap 'kill %1; kill %2; kill %3; kill %4; kill %5' SIGINT

      cd #{libexec}
      java `cat conf-quickstart/druid/historical/jvm.config | xargs` -cp "conf-quickstart/druid/_common:conf-quickstart/druid/historical:lib/*" io.druid.cli.Main server historical &
      java `cat conf-quickstart/druid/broker/jvm.config | xargs` -cp "conf-quickstart/druid/_common:conf-quickstart/druid/broker:lib/*" io.druid.cli.Main server broker &
      java `cat conf-quickstart/druid/coordinator/jvm.config | xargs` -cp "conf-quickstart/druid/_common:conf-quickstart/druid/coordinator:lib/*" io.druid.cli.Main server coordinator &
      java `cat conf-quickstart/druid/overlord/jvm.config | xargs` -cp "conf-quickstart/druid/_common:conf-quickstart/druid/overlord:lib/*" io.druid.cli.Main server overlord &
      java `cat conf-quickstart/druid/middleManager/jvm.config | xargs` -cp "conf-quickstart/druid/_common:conf-quickstart/druid/middleManager:lib/*" io.druid.cli.Main server middleManager &
      wait
    EOS
  end

  test do
    begin
      pid = fork { exec "#{bin}/druid &> /dev/null" }
      sleep 60
      output = shell_output("curl -s http://localhost:8082/status")
      assert_match /version/m, output
    ensure
      Process.kill "INT", pid
    end
  end
end
