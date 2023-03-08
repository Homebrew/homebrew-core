class Jenkins < Formula
  desc "Extendable open source continuous integration server"
  homepage "https://www.jenkins.io/"
  url "https://get.jenkins.io/war/2.394/jenkins.war"
  sha256 "2cbedbd7b08067da8dc39874e383a76103eb1ed41dd437945b50040cdb700270"
  license "MIT"

  livecheck do
    url "https://www.jenkins.io/download/"
    regex(%r{href=.*?/war/v?(\d+(?:\.\d+)+)/jenkins\.war}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "842c714eeddb39b37930df6dfb4399482b41cf421b017f35f00faf4903230035"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "842c714eeddb39b37930df6dfb4399482b41cf421b017f35f00faf4903230035"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "842c714eeddb39b37930df6dfb4399482b41cf421b017f35f00faf4903230035"
    sha256 cellar: :any_skip_relocation, ventura:        "842c714eeddb39b37930df6dfb4399482b41cf421b017f35f00faf4903230035"
    sha256 cellar: :any_skip_relocation, monterey:       "842c714eeddb39b37930df6dfb4399482b41cf421b017f35f00faf4903230035"
    sha256 cellar: :any_skip_relocation, big_sur:        "842c714eeddb39b37930df6dfb4399482b41cf421b017f35f00faf4903230035"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef2e41dedeed20a5052aa40ee3631bcf378ba531f57b8f417d879722ea0652ec"
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
