class JenkinsLts < Formula
  desc "Extendable open source continuous integration server"
  homepage "https://www.jenkins.io/"
  url "https://get.jenkins.io/war-stable/2.401.1/jenkins.war"
  sha256 "600b73eabf797852e39919541b84f7686ff601b97c77b44eb00843eb91c7dd6c"
  license "MIT"

  livecheck do
    url "https://www.jenkins.io/download/"
    regex(%r{href=.*?/war-stable/v?(\d+(?:\.\d+)+)/jenkins\.war}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c3cad12ffc74ce016c5eb89799681c9baa8e12bfbb47a0de76a646c8f557c0b1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c3cad12ffc74ce016c5eb89799681c9baa8e12bfbb47a0de76a646c8f557c0b1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c3cad12ffc74ce016c5eb89799681c9baa8e12bfbb47a0de76a646c8f557c0b1"
    sha256 cellar: :any_skip_relocation, ventura:        "c3cad12ffc74ce016c5eb89799681c9baa8e12bfbb47a0de76a646c8f557c0b1"
    sha256 cellar: :any_skip_relocation, monterey:       "c3cad12ffc74ce016c5eb89799681c9baa8e12bfbb47a0de76a646c8f557c0b1"
    sha256 cellar: :any_skip_relocation, big_sur:        "c3cad12ffc74ce016c5eb89799681c9baa8e12bfbb47a0de76a646c8f557c0b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b34fe71cab1119e8787018d46aacb2928eeb124554b2f4c5fabd6905274f9d7d"
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
