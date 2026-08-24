class JenkinsLts < Formula
  desc "Extendable open source continuous integration server"
  homepage "https://www.jenkins.io/"
  url "https://get.jenkins.io/war-stable/2.568.2/jenkins.war"
  sha256 "9bbb2b329e52730ba7decd1a7a1095987f6250ec761fb21157dbb2cbcd1ef590"
  license "MIT"

  livecheck do
    url "https://www.jenkins.io/download/"
    regex(%r{href=.*?/war-stable/v?(\d+(?:\.\d+)+)/jenkins\.war}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1799782f5d25e847277dc26702aed8a46019d019f0891e22f336a30f44275cc4"
  end

  depends_on "openjdk@21"

  def install
    system "#{formula_opt_bin("openjdk@21")}/jar", "xvf", "jenkins.war"
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
      formula_opt_bin("openjdk@21")/"java",
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
