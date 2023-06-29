class JenkinsLts < Formula
  desc "Extendable open source continuous integration server"
  homepage "https://www.jenkins.io/"
  url "https://get.jenkins.io/war-stable/2.401.2/jenkins.war"
  sha256 "86bd8e0b2b51075c99b00d43603c2858440bf011ecd089a5c791d0c964d40682"
  license "MIT"

  livecheck do
    url "https://www.jenkins.io/download/"
    regex(%r{href=.*?/war-stable/v?(\d+(?:\.\d+)+)/jenkins\.war}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ac5879ac520e60255b18277949ac83d79483f44b49ea65154ffc48c99466f10a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ac5879ac520e60255b18277949ac83d79483f44b49ea65154ffc48c99466f10a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ac5879ac520e60255b18277949ac83d79483f44b49ea65154ffc48c99466f10a"
    sha256 cellar: :any_skip_relocation, ventura:        "ac5879ac520e60255b18277949ac83d79483f44b49ea65154ffc48c99466f10a"
    sha256 cellar: :any_skip_relocation, monterey:       "ac5879ac520e60255b18277949ac83d79483f44b49ea65154ffc48c99466f10a"
    sha256 cellar: :any_skip_relocation, big_sur:        "ac5879ac520e60255b18277949ac83d79483f44b49ea65154ffc48c99466f10a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "364aaf533cde1913bd8dd80483899687d222c962f431c5263781edb3491ff443"
  end

  depends_on "openjdk@17"

  def install
    system "#{Formula["openjdk@17"].opt_bin}/jar", "xvf", "jenkins.war"
    libexec.install "jenkins.war", "WEB-INF/lib/cli-#{version}.jar"
    bin.write_jar_script libexec/"jenkins.war", "jenkins-lts", java_version: "17"
    bin.write_jar_script libexec/"cli-#{version}.jar", "jenkins-lts-cli", java_version: "17"
  end

  def caveats
    <<~EOS
      Note: When using launchctl the port will be 8080.
    EOS
  end

  service do
    run [Formula["openjdk@17"].opt_bin/"java", "-Dmail.smtp.starttls.enable=true", "-jar", opt_libexec/"jenkins.war",
         "--httpListenAddress=127.0.0.1", "--httpPort=8080"]
  end

  test do
    ENV["JENKINS_HOME"] = testpath
    ENV.prepend "_JAVA_OPTIONS", "-Djava.io.tmpdir=#{testpath}"

    port = free_port
    fork do
      exec "#{bin}/jenkins-lts --httpPort=#{port}"
    end
    sleep 60

    output = shell_output("curl localhost:#{port}/")
    assert_match(/Welcome to Jenkins!|Unlock Jenkins|Authentication required/, output)
  end
end
