class Jenkins < Formula
  desc "Extendable open source continuous integration server"
  homepage "https://www.jenkins.io/"
  url "https://get.jenkins.io/war/2.433/jenkins.war"
  sha256 "c392a8cac764164e1784c40b4444c523bd948d42f57abac882ebfa7bf8813887"
  license "MIT"

  livecheck do
    url "https://www.jenkins.io/download/"
    regex(%r{href=.*?/war/v?(\d+(?:\.\d+)+)/jenkins\.war}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f921116e1aabf2aef8a55ff9f39d950bd45a80a7942bf36371c903af76172b6c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f921116e1aabf2aef8a55ff9f39d950bd45a80a7942bf36371c903af76172b6c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f921116e1aabf2aef8a55ff9f39d950bd45a80a7942bf36371c903af76172b6c"
    sha256 cellar: :any_skip_relocation, sonoma:         "f921116e1aabf2aef8a55ff9f39d950bd45a80a7942bf36371c903af76172b6c"
    sha256 cellar: :any_skip_relocation, ventura:        "f921116e1aabf2aef8a55ff9f39d950bd45a80a7942bf36371c903af76172b6c"
    sha256 cellar: :any_skip_relocation, monterey:       "f921116e1aabf2aef8a55ff9f39d950bd45a80a7942bf36371c903af76172b6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a678a5e30f54a078dabfed7c5bbac546695e238e24760ec54a65bd95b6644796"
  end

  head do
    url "https://github.com/jenkinsci/jenkins.git", branch: "master"
    depends_on "maven" => :build
  end

  depends_on "openjdk"

  def install
    if build.head?
      system "mvn", "clean", "install", "-pl", "war", "-am", "-DskipTests"
    else
      system "#{Formula["openjdk"].opt_bin}/jar", "xvf", "jenkins.war"
    end
    libexec.install Dir["**/jenkins.war", "**/cli-#{version}.jar"]
    bin.write_jar_script libexec/"jenkins.war", "jenkins"
    bin.write_jar_script libexec/"cli-#{version}.jar", "jenkins-cli"

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
    fork do
      exec "#{bin}/jenkins --httpPort=#{port}"
    end
    sleep 60

    output = shell_output("curl localhost:#{port}/")
    assert_match(/Welcome to Jenkins!|Unlock Jenkins|Authentication required/, output)
  end
end
