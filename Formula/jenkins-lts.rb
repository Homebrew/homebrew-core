class JenkinsLts < Formula
  desc "Extendable open-source CI server"
  homepage "https://jenkins.io/index.html#stable"
  url "http://mirrors.jenkins.io/war-stable/2.222.1/jenkins.war"
  sha256 "5a6cbb836ceb79728c2d9f72645d0680f789cdb09a44485076aba6143bea953e"

  bottle :unneeded

  depends_on :java => "1.8"

  def install
    system "jar", "xvf", "jenkins.war"
    libexec.install "jenkins.war", "WEB-INF/lib/cli-#{version}.jar"
    bin.write_jar_script libexec/"jenkins.war", "jenkins-lts", :java_version => "1.8"
    bin.write_jar_script libexec/"cli-#{version}.jar", "jenkins-lts-cli", :java_version => "1.8"
  end

  def caveats
    <<~EOS
      Note: When using launchctl the port will be 8080.
    EOS
  end

  plist_options :manual => "jenkins-lts"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>ProgramArguments</key>
          <array>
            <string>/usr/libexec/java_home</string>
            <string>-v</string>
            <string>1.8</string>
            <string>--exec</string>
            <string>java</string>
            <string>-Dmail.smtp.starttls.enable=true</string>
            <string>-jar</string>
            <string>#{opt_libexec}/jenkins.war</string>
            <string>--httpListenAddress=127.0.0.1</string>
            <string>--httpPort=8080</string>
          </array>
          <key>RunAtLoad</key>
          <true/>
        </dict>
      </plist>
    EOS
  end

  test do
    ENV["JENKINS_HOME"] = testpath
    ENV.prepend "_JAVA_OPTIONS", "-Djava.io.tmpdir=#{testpath}"

    port = free_port
    pid = fork do
      exec "#{bin}/jenkins-lts --httpPort=#{port}"
    end
    sleep 60

    begin
      output = shell_output("curl localhost:#{port}/")
      assert_match(/Welcome to Jenkins!|Unlock Jenkins|Authentication required/, output)
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
