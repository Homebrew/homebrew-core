class JenkinsLts < Formula
  desc "Extendable open source continuous integration server"
  homepage "https://www.jenkins.io/"
  url "https://get.jenkins.io/war-stable/2.541.1/jenkins.war"
  sha256 "8b12678aa6f9550b06825b006f9096186b17a7b857e9b68ad3f980d9f430fc94"
  license "MIT"

  livecheck do
    url "https://www.jenkins.io/download/"
    regex(%r{href=.*?/war-stable/v?(\d+(?:\.\d+)+)/jenkins\.war}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d9990e2e6ebaff3c9b10edceed09f6a117969f7d24a1a9303e6c6b255bc85682"
  end

  depends_on "openjdk@21"

  def install
    system "#{Formula["openjdk@21"].opt_bin}/jar", "xvf", "jenkins.war"
    libexec.install "jenkins.war", "WEB-INF/lib/cli-#{version}.jar"
    bin.write_jar_script libexec/"jenkins.war", "jenkins-lts", java_version: "21"
    bin.write_jar_script libexec/"cli-#{version}.jar", "jenkins-lts-cli", java_version: "21"
  end

  def caveats
    <<~EOS
      Note: When using launchctl the port will be 8080.
    EOS
  end

  service do
    run [Formula["openjdk@21"].opt_bin/"java", "-Dmail.smtp.starttls.enable=true", "-jar", opt_libexec/"jenkins.war",
         "--httpListenAddress=127.0.0.1", "--httpPort=8080"]
  end

  test do
    ENV["JENKINS_HOME"] = testpath
    ENV.prepend "_JAVA_OPTIONS", "-Djava.io.tmpdir=#{testpath}"

    port = free_port
    spawn bin/"jenkins-lts", "--httpPort=#{port}"

    output = shell_output("curl --silent --retry 5 --retry-connrefused localhost:#{port}/")
    assert_match(/Welcome to Jenkins!|Unlock Jenkins|Authentication required/, output)
  end
end
