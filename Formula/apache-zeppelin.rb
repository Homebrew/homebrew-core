class ApacheZeppelin < Formula
  desc "Web-based notebook that enables interactive data analytics"
  homepage "https://zeppelin.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=zeppelin/zeppelin-0.7.1/zeppelin-0.7.1-bin-all.tgz"
  sha256 "eaa7c34bb7e4dd0e722f330fe524e361cd8f05980dad214f92f5d6701861f3d8"
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
        export ZEPPELIN_NOTEBOOK_DIR="#{testpath}/notebooks"
        export ZEPPELIN_MEM="-Xms256m -Xmx1024m -XX:MaxPermSize=256m"
      EOF
      ln_s "#{libexec}/conf/log4j.properties", conf
      ln_s "#{libexec}/conf/shiro.ini", conf
      system "#{bin}/zeppelin-daemon.sh", "start"
      begin
        sleep 25
        json_text = shell_output("curl -s http://localhost:9999/api/notebook/")
        assert_equal JSON.parse(json_text)["status"], "OK"
      ensure
        system "#{bin}/zeppelin-daemon.sh", "stop"
      end
    end
  end
end
