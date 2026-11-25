class JenkinsLts < Formula
  desc "Extendable open source continuous integration server"
  homepage "https://www.jenkins.io/"
  url "https://get.jenkins.io/war-stable/2.580.3/jenkins.war"
  sha256 "39f69dbd41d78b050183684f81e2eb581bf032ed1c529e5d8fa8884b5fd062e2"
  license "MIT"

  livecheck do
    url "https://www.jenkins.io/download/"
    regex(%r{href=.*?/war-stable/v?(\d+(?:\.\d+)+)/jenkins\.war}i)
  end

  bottle do
    manifest_sha256 "9a1b2d39e2c52ccba589574eb90fd498baaf889bc46cc3e9ba83d7c3d20d5382"
    sha256 cellar: :any_skip_relocation, all: "1264588db925a4f3d62de092b7a222cc95275032ebd8383320a0d6c1bc3f8fbd"
  end

  depends_on "openjdk@21"

  def install
    system dep("openjdk").opt_bin/"jar", "xvf", "jenkins.war"
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
    run [
      f.dep("openjdk").opt_bin/"java",
      "-Dmail.smtp.starttls.enable=true",
      "-jar",
      opt_libexec/"jenkins.war",
      "--httpListenAddress=127.0.0.1",
      "--httpPort=8080",
    ]
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
