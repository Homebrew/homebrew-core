class Hertzbeat < Formula
  desc "Real-time monitoring system with agentless, performance cluster capabilities"
  homepage "https://hertzbeat.apache.org/"
  url "https://dlcdn.apache.org/incubator/hertzbeat/1.7.0/apache-hertzbeat-1.7.0-incubating-bin.tar.gz"
  sha256 "c593aa8f3e1ae74f2b093bffe60167f5b5780a21a35dde95ed243f1c9bd2e46b"
  license "Apache-2.0"

  depends_on "openjdk@17"

  def install
    libexec.install Dir["*"]

    (libexec/"bin/custom-startup.sh").write <<~EOS
      #!/bin/bash
      cd "$(dirname "$0")"/.. || exit

      JVM_OPTS="-Duser.timezone=Asia/Shanghai -Doracle.jdbc.timezoneAsRegion=false -server -XX:SurvivorRatio=6 -XX:+UseParallelGC -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=logs"

      LOG_OPTS="-Dlogging.path=logs -Dlogging.config=config/logback-spring.xml -Dspring.config.location=config/"

      export JAVA_OPTS="$JVM_OPTS $LOG_OPTS"

      exec java $JAVA_OPTS -cp apache-hertzbeat-1.7.0.jar:ext-lib/* org.apache.hertzbeat.manager.Manager
    EOS

    (libexec/"bin/custom-shutdown.sh").write <<~EOS
      #!/bin/bash
      cd "$(dirname "$0")"/.. || exit
      ./bin/shutdown.sh
    EOS

    chmod 0755, libexec/"bin/custom-startup.sh"
    chmod 0755, libexec/"bin/custom-shutdown.sh"

    (bin/"hertzbeat").write_env_script libexec/"bin/custom-startup.sh",
                                        Language::Java.overridable_java_home_env("17")
    (bin/"hertzbeat-shutdown").write_env_script libexec/"bin/custom-shutdown.sh",
                                                Language::Java.overridable_java_home_env("17")

    (var/"hertzbeat").mkpath
    (var/"log/hertzbeat").mkpath

    ln_sf var/"hertzbeat", libexec/"data"
    ln_sf var/"log/hertzbeat", libexec/"logs"
  end

  def post_install
    (var/"hertzbeat").mkpath
    (var/"log/hertzbeat").mkpath

    chmod 0755, var/"hertzbeat"
    chmod 0755, var/"log/hertzbeat"

    cp_r "#{libexec}/config", "#{var}/hertzbeat/" if Dir["#{var}/hertzbeat/config"].empty?

    %w[cache data].each do |dir|
      if Dir.exist?("#{libexec}/#{dir}") && Dir["#{var}/hertzbeat/#{dir}"].empty?
        cp_r "#{libexec}/#{dir}", "#{var}/hertzbeat/"
      end
    end
  end

  def caveats
    <<~EOS
      HertzBeat has been installed.

      Data directory: #{var}/hertzbeat
      Logs directory: #{var}/log/hertzbeat

      To start HertzBeat manually:
        hertzbeat

      To stop HertzBeat manually:
        hertzbeat-shutdown

      To access HertzBeat web interface:
        http://localhost:1157

      Default login credentials:
        Username: admin
        Password: hertzbeat
    EOS
  end

  service do
    run opt_bin/"hertzbeat"
    keep_alive true
    log_path var/"log/hertzbeat/hertzbeat.log"
    error_log_path var/"log/hertzbeat/hertzbeat.log"
    working_dir opt_libexec
    environment_variables JAVA_HOME:      Formula["openjdk@17"].opt_prefix,
                          HERTZBEAT_HOME: opt_libexec.to_s
  end

  test do
    # 检查Java依赖是否可用
    system Formula["openjdk@17"].opt_bin/"java", "-version"
    
    # 检查主JAR文件是否存在
    jar_file = "#{libexec}/apache-hertzbeat-1.7.0.jar"
    assert_predicate Pathname.new(jar_file), :exist?
    
    # 版本检查，使用java直接输出版本信息
    assert_match "HertzBeat", shell_output("#{Formula["openjdk@17"].opt_bin}/java -jar #{jar_file} --version 2>&1", 1)
    
    # 检查核心文件夹是否存在
    %w[bin config lib].each do |dir|
      assert_predicate libexec/dir, :exist?
    end
    
    # 测试配置文件是否存在
    assert_predicate libexec/"config/application.yml", :exist?
  end
end
