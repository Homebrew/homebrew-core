class JenkinsLts < Formula
  desc "Extendable open source continuous integration server"
  homepage "https://www.jenkins.io/"
  url "https://get.jenkins.io/war-stable/2.387.1/jenkins.war"
  sha256 "c132a1e00b685afc7996eba530be428a3279c649399417f9fa38fcbc0dbec027"
  license "MIT"

  livecheck do
    url "https://www.jenkins.io/download/"
    regex(%r{href=.*?/war-stable/v?(\d+(?:\.\d+)+)/jenkins\.war}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1e51b84a789c6ab35e987a1862389780ee8e67f6121927c956e7d525f86d3a91"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e51b84a789c6ab35e987a1862389780ee8e67f6121927c956e7d525f86d3a91"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1e51b84a789c6ab35e987a1862389780ee8e67f6121927c956e7d525f86d3a91"
    sha256 cellar: :any_skip_relocation, ventura:        "1e51b84a789c6ab35e987a1862389780ee8e67f6121927c956e7d525f86d3a91"
    sha256 cellar: :any_skip_relocation, monterey:       "1e51b84a789c6ab35e987a1862389780ee8e67f6121927c956e7d525f86d3a91"
    sha256 cellar: :any_skip_relocation, big_sur:        "1e51b84a789c6ab35e987a1862389780ee8e67f6121927c956e7d525f86d3a91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ffbbf3e649f9066e11bc0867a7fff3e6ce53e3cb7cf1bd37dfa702805dddd018"
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
