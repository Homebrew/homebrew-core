class Jenkins < Formula
  desc "Extendable open source continuous integration server"
  homepage "https://www.jenkins.io/"
  url "https://get.jenkins.io/war/2.592/jenkins.war"
  sha256 "26315aa6c9aee57eaa4bce6347bcbcf32b06ef2e53871ed21ff2a23eea524d11"
  license "MIT"

  livecheck do
    url "https://www.jenkins.io/download/"
    regex(%r{href=.*?/war/v?(\d+(?:\.\d+)+)/jenkins\.war}i)
  end

  bottle do
    manifest_sha256 "5606997bdbbd664e1a28c02d42e7743ba3baac97e4131368ca6ecf22c84ff863"
    sha256 cellar: :any_skip_relocation, all: "9949da08b756955e81ec435e8277ee8c579d5436da85953574fcc85347e80fae"
  end

  head do
    url "https://github.com/jenkinsci/jenkins.git", branch: "master"
    depends_on "maven" => :build
  end

  depends_on "openjdk@21"

  def install
    if build.head?
      system "mvn", "clean", "install", "-pl", "war", "-am", "-DskipTests"
    else
      system dep("openjdk").opt_bin/"jar", "xvf", "jenkins.war"
    end
    libexec.install Dir["**/jenkins.war", "**/cli-#{version}.jar"]
    bin.write_jar_script libexec/"jenkins.war", "jenkins", java_version: "21"
    bin.write_jar_script libexec/"cli-#{version}.jar", "jenkins-cli", java_version: "21"

    (var/"log/jenkins").mkpath
  end

  def caveats
    <<~EOS
      Note: When using launchctl the port will be 8080.
    EOS
  end

  service do
    run [opt_bin/"jenkins", "--httpListenAddress=127.0.0.1", "--httpPort=8080"]
    keep_alive true
    log_path var/"log/jenkins/output.log"
    error_log_path var/"log/jenkins/error.log"
  end

  test do
    ENV["JENKINS_HOME"] = testpath
    ENV.prepend "_JAVA_OPTIONS", "-Djava.io.tmpdir=#{testpath}"

    port = free_port
    spawn bin/"jenkins", "--httpPort=#{port}"

    output = shell_output("curl --silent --retry 5 --retry-connrefused localhost:#{port}/")
    assert_match(/Welcome to Jenkins!|Unlock Jenkins|Authentication required/, output)
  end
end
