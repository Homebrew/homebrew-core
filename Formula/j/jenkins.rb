class Jenkins < Formula
  desc "Extendable open source continuous integration server"
  homepage "https://www.jenkins.io/"
  url "https://get.jenkins.io/war/2.430/jenkins.war"
  sha256 "8f603a9120dd481c9d3986c6624731869a3731ad560e7d0fdaebe0722efdc365"
  license "MIT"

  livecheck do
    url "https://www.jenkins.io/download/"
    regex(%r{href=.*?/war/v?(\d+(?:\.\d+)+)/jenkins\.war}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fc254070a2f3328b3bce683ff85e471c1bd09a610fea77582068d00f2f20eedb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fc254070a2f3328b3bce683ff85e471c1bd09a610fea77582068d00f2f20eedb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc254070a2f3328b3bce683ff85e471c1bd09a610fea77582068d00f2f20eedb"
    sha256 cellar: :any_skip_relocation, sonoma:         "fc254070a2f3328b3bce683ff85e471c1bd09a610fea77582068d00f2f20eedb"
    sha256 cellar: :any_skip_relocation, ventura:        "fc254070a2f3328b3bce683ff85e471c1bd09a610fea77582068d00f2f20eedb"
    sha256 cellar: :any_skip_relocation, monterey:       "fc254070a2f3328b3bce683ff85e471c1bd09a610fea77582068d00f2f20eedb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "293b7f032bdb6a7646f186ff273cd36334e7f61275d9de83392587b5555270eb"
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
