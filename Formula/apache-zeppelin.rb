class ApacheZeppelin < Formula
  desc "Web-based notebook that enables interactive data analytics"
  homepage "https://zeppelin.apache.org"
  url "https://www-eu.apache.org/dist/zeppelin/zeppelin-0.7.0/zeppelin-0.7.0-bin-all.tgz"
  sha256 "196f92122f3c109ddbf48bce50b3bb9d873f351c414b858d90d105f07e379bb1"
  head "https://github.com/apache/zeppelin.git"

  bottle :unneeded

  def install
    rm_f Dir["bin/*.cmd"]
    libexec.install Dir["*"]
    bin.write_exec_script Dir["#{libexec}/bin/*"]
  end

  test do
    begin
      ENV["ZEPPELIN_LOG_DIR"] = "logs"
      ENV["ZEPPELIN_PID_DIR"] = "pid"
      ENV["ZEPPELIN_CONF_DIR"] = "#{testpath}/conf"
      conf = testpath/"conf"
      conf.mkdir
      (conf/"zeppelin-env.sh").write <<-EOF.undent
        export ZEPPELIN_WAR_TEMPDIR="#{testpath}/webapps"
        export ZEPPELIN_PORT=9999
      EOF
      ln_s "#{libexec}/conf/log4j.properties", conf
      ln_s "#{libexec}/conf/shiro.ini", conf
      system "#{bin}/zeppelin-daemon.sh", "start"
      begin
        jettystart = 0
        jettyrunning = false
        while not jettyrunning
          sleep 1
          jettystart += 1
          lsof = shell_output("lsof -i -n -P")
          jettyrunning = lsof.include? "TCP *:9999"
        end
        puts "Waited for jetty: ", jettystart

        zeprunning = false
        zepstart = 0
        while not zeprunning
          sleep 5
          zepstart += 5
          resp = shell_output("curl -s http://localhost:9999/api/notebook")
          begin
            JSON.parse(resp)
            zeprunning = true
          rescue
          end
        end
        puts "Waited for zeppelin: ", zepstart
        json_text = shell_output("curl -s http://localhost:9999/api/notebook/")
        assert_operator JSON.parse(json_text)["body"].length, :>=, 1
      ensure
        system "#{bin}/zeppelin-daemon.sh", "stop"
      end
    end
  end
end
