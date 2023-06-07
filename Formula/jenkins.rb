class Jenkins < Formula
  desc "Extendable open source continuous integration server"
  homepage "https://www.jenkins.io/"
  url "https://get.jenkins.io/war/2.409/jenkins.war"
  sha256 "ab12751b2f4f128df8f700911a383cba7eefcf09959f659f4b560d7019933e7f"
  license "MIT"

  livecheck do
    url "https://www.jenkins.io/download/"
    regex(%r{href=.*?/war/v?(\d+(?:\.\d+)+)/jenkins\.war}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d4dfd39a42fba13357c46068f3965721ca9392912c8d71ca21ab33a01406181f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d4dfd39a42fba13357c46068f3965721ca9392912c8d71ca21ab33a01406181f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d4dfd39a42fba13357c46068f3965721ca9392912c8d71ca21ab33a01406181f"
    sha256 cellar: :any_skip_relocation, ventura:        "d4dfd39a42fba13357c46068f3965721ca9392912c8d71ca21ab33a01406181f"
    sha256 cellar: :any_skip_relocation, monterey:       "d4dfd39a42fba13357c46068f3965721ca9392912c8d71ca21ab33a01406181f"
    sha256 cellar: :any_skip_relocation, big_sur:        "d4dfd39a42fba13357c46068f3965721ca9392912c8d71ca21ab33a01406181f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4070e0313709ee24d7cb0636324d3a30557eb457f4289547001fd53504e1a092"
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
