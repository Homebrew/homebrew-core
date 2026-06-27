class JenkinsLts < Formula
  desc "Extendable open source continuous integration server"
  homepage "https://www.jenkins.io/"
  url "https://get.jenkins.io/war-stable/2.555.3/jenkins.war"
  sha256 "5d19905e6c0f23aff89ff007de5564b96e0a05c13f4d1a92d0fdcb69b033bb9a"
  license "MIT"

  livecheck do
    url "https://www.jenkins.io/download/"
    regex(%r{href=.*?/war-stable/v?(\d+(?:\.\d+)+)/jenkins\.war}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "54778d2d0d56420760fa49a4e3bedbf7fa551063cb1c402f0b67f788c213c34f"
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
