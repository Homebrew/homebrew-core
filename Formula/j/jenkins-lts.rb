class JenkinsLts < Formula
  desc "Extendable open source continuous integration server"
  homepage "https://www.jenkins.io/"
  url "https://get.jenkins.io/war-stable/2.452.2/jenkins.war"
  sha256 "360efc8438db9a4ba20772981d4257cfe6837bf0c3fb8c8e9b2253d8ce6ba339"
  license "MIT"

  livecheck do
    url "https://www.jenkins.io/download/"
    regex(%r{href=.*?/war-stable/v?(\d+(?:\.\d+)+)/jenkins\.war}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "adc942baa22409b0f474cb1fbfa5a73d97fcb0f893d73e7a1d12e6d5b5189d4e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "adc942baa22409b0f474cb1fbfa5a73d97fcb0f893d73e7a1d12e6d5b5189d4e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "adc942baa22409b0f474cb1fbfa5a73d97fcb0f893d73e7a1d12e6d5b5189d4e"
    sha256 cellar: :any_skip_relocation, sonoma:         "72e40e5fb0fff3e42f3e866468aadbb522c04857fd683a010df27b5bdb4c7122"
    sha256 cellar: :any_skip_relocation, ventura:        "72e40e5fb0fff3e42f3e866468aadbb522c04857fd683a010df27b5bdb4c7122"
    sha256 cellar: :any_skip_relocation, monterey:       "adc942baa22409b0f474cb1fbfa5a73d97fcb0f893d73e7a1d12e6d5b5189d4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "781bb5f310fa36ba0f58aad015c7aaecef56e1f12986d6ce13baf5ca349ba3a5"
  end

  depends_on "openjdk@21"

  def install
    system "#{Formula["openjdk@21"].opt_bin}/jar", "xvf", "jenkins.war"
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
    run [Formula["openjdk@21"].opt_bin/"java", "-Dmail.smtp.starttls.enable=true", "-jar", opt_libexec/"jenkins.war",
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
