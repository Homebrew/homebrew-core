class JettyRunner < Formula
  desc "Use Jetty without an installed distribution"
  homepage "https://www.eclipse.org/jetty/"
  url "https://search.maven.org/remotecontent?filepath=org/eclipse/jetty/jetty-runner/9.4.15.v20190215/jetty-runner-9.4.15.v20190215.jar"
  version "9.4.15.v20190215"
  sha256 "4412775d61999b173106d7608ac13b7c8b4066ef85a8ea1279021483166f6596"
  revision 1

  bottle :unneeded

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]

    (bin/"jetty-runner").write <<~EOS
      #!/bin/bash
      export JAVA_HOME="${JAVA_HOME:-#{Formula["openjdk"].opt_prefix}}"
      exec "${JAVA_HOME}/bin/java" -jar "#{libexec}/jetty-runner-#{version}.jar" "$@"
    EOS
  end

  test do
    ENV.append "_JAVA_OPTIONS", "-Djava.io.tmpdir=#{testpath}"
    touch "#{testpath}/test.war"

    pid = fork do
      exec "#{bin}/jetty-runner test.war"
    end
    sleep 5

    begin
      output = shell_output("curl -I http://localhost:8080")
      assert_match %r{HTTP\/1\.1 200 OK}, output
    ensure
      Process.kill 9, pid
      Process.wait pid
    end
  end
end
