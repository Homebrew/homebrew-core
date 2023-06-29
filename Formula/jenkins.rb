class Jenkins < Formula
  desc "Extendable open source continuous integration server"
  homepage "https://www.jenkins.io/"
  url "https://get.jenkins.io/war/2.412/jenkins.war"
  sha256 "a54e3f1f70e95954f57e169dbc53207f062a67c48b8d14b8f94a640215e3847a"
  license "MIT"

  livecheck do
    url "https://www.jenkins.io/download/"
    regex(%r{href=.*?/war/v?(\d+(?:\.\d+)+)/jenkins\.war}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ed921114e1432f12b9d3a31ec4bd01191cd5854b315fcbd2e7bbf136eb74f94e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed921114e1432f12b9d3a31ec4bd01191cd5854b315fcbd2e7bbf136eb74f94e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ed921114e1432f12b9d3a31ec4bd01191cd5854b315fcbd2e7bbf136eb74f94e"
    sha256 cellar: :any_skip_relocation, ventura:        "ed921114e1432f12b9d3a31ec4bd01191cd5854b315fcbd2e7bbf136eb74f94e"
    sha256 cellar: :any_skip_relocation, monterey:       "ed921114e1432f12b9d3a31ec4bd01191cd5854b315fcbd2e7bbf136eb74f94e"
    sha256 cellar: :any_skip_relocation, big_sur:        "ed921114e1432f12b9d3a31ec4bd01191cd5854b315fcbd2e7bbf136eb74f94e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61168390985e1d06c1f4b9724409d4935ee04519bf7c6d3fa20e3b506daa6bd0"
  end

  head do
    url "https://github.com/jenkinsci/jenkins.git", branch: "master"
    depends_on "maven" => :build
  end

  depends_on "openjdk@17"

  def install
    if build.head?
      system "mvn", "clean", "install", "-pl", "war", "-am", "-DskipTests"
    else
      system "#{Formula["openjdk@17"].opt_bin}/jar", "xvf", "jenkins.war"
    end
    libexec.install Dir["**/jenkins.war", "**/cli-#{version}.jar"]
    bin.write_jar_script libexec/"jenkins.war", "jenkins", java_version: "17"
    bin.write_jar_script libexec/"cli-#{version}.jar", "jenkins-cli", java_version: "17"

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
