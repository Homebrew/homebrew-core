class JettyRunner < Formula
  desc "Use Jetty without an installed distribution"
  homepage "https://www.eclipse.org/jetty/documentation/9.3.10.v20160621/runner.html"
  url "https://search.maven.org/remotecontent?filepath=org/eclipse/jetty/jetty-runner/9.3.10.v20160621/jetty-runner-9.3.10.v20160621.jar"
  version "9.3.10.v20160621"
  sha256 "1dd8773ec7d4cedc15d5f99f13ff68ff04c3917b801942e02d07336a0d011bab"

  bottle :unneeded

  def install
    libexec.install Dir["*"]

    bin.mkpath
    bin.write_jar_script libexec/"jetty-runner-#{version}.jar", "jetty-runner"
  end
end
