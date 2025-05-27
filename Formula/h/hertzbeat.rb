class Hertzbeat < Formula
  desc "Real-time monitoring system with agentless, performance cluster capabilities"
  homepage "https://hertzbeat.apache.org/"
  url "https://dlcdn.apache.org/incubator/hertzbeat/1.7.0/apache-hertzbeat-1.7.0-incubating-bin.tar.gz"
  sha256 "c593aa8f3e1ae74f2b093bffe60167f5b5780a21a35dde95ed243f1c9bd2e46b"
  license "Apache-2.0"

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]

    (libexec/"bin/brew-startup.sh").write <<~EOS
      #!/bin/bash
      cd "$(dirname "$0")"/.. || exit

      JVM_OPTS="-Duser.timezone=Asia/Shanghai -Doracle.jdbc.timezoneAsRegion=false -server -XX:SurvivorRatio=6 -XX:+UseParallelGC -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=logs"

      # Add H2 database specific options to prevent permission issues
      H2_OPTS="-Dh2.bindAddress=127.0.0.1 -Dh2.directory=data -Dh2.allowedClasses=* -Dh2.serverCachedObjects=3000"

      LOG_OPTS="-Dlogging.path=logs -Dlogging.config=config/logback-spring.xml -Dspring.config.location=config/"

      export JAVA_OPTS="$JVM_OPTS $H2_OPTS $LOG_OPTS"

      exec java $JAVA_OPTS -cp apache-hertzbeat-1.7.0.jar:ext-lib/* org.apache.hertzbeat.manager.Manager
    EOS

    chmod 0755, libexec/"bin/brew-startup.sh"

    (bin/"hertzbeat").write_env_script libexec/"bin/brew-startup.sh", Language::Java.overridable_java_home_env

    (var/"hertzbeat").mkpath
    (var/"log/hertzbeat").mkpath

    ln_sf var/"hertzbeat", libexec/"data"
    ln_sf var/"log/hertzbeat", libexec/"logs"
  end

  def post_install
    (var/"hertzbeat").mkpath
    (var/"log/hertzbeat").mkpath
    chmod 0775, var/"hertzbeat"
    chmod 0775, var/"log/hertzbeat"
    if Dir["#{var}/hertzbeat/config"].empty?
      cp_r "#{libexec}/config", "#{var}/hertzbeat/"
      chmod_R 0775, var/"hertzbeat/config"
    end
    %w[cache data].each do |dir|
      if Dir.exist?("#{libexec}/#{dir}") && Dir["#{var}/hertzbeat/#{dir}"].empty?
        cp_r "#{libexec}/#{dir}", "#{var}/hertzbeat/"
        chmod_R 0775, var/"hertzbeat/#{dir}"
      end
    end
    # Pre-create H2 database files with correct permissions
    # This prevents permission issues when the service tries to create these files
    %w[hertzbeat.mv.db hertzbeat.trace.db].each do |db_file|
      db_path = "#{var}/hertzbeat/#{db_file}"
      unless File.exist?(db_path)
        touch db_path
        chmod 0664, db_path
      end
    end
  end

  service do
    run opt_bin/"hertzbeat"
    keep_alive true
    log_path var/"log/hertzbeat/hertzbeat.log"
    error_log_path var/"log/hertzbeat/hertzbeat.log"
    working_dir opt_libexec
    environment_variables JAVA_HOME:      Formula["openjdk"].opt_prefix,
                          HERTZBEAT_HOME: opt_libexec.to_s
  end

  test do
    port = 1157
    ENV["QUERY_PORT"] = port.to_s

    spawn bin/"hertzbeat"
    sleep 20

    response = shell_output("curl -s -u 'admin:hertzbeat' 127.0.0.1:#{port}/actuator/health")
    assert_equal '{"status":"UP"}', response.strip
  end
end
