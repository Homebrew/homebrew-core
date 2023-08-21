class JenkinsLts < Formula
  desc "Extendable open source continuous integration server"
  homepage "https://www.jenkins.io/"
  url "https://get.jenkins.io/war-stable/2.401.3/jenkins.war"
  sha256 "a798a0c5481a8ffb0320d9121f6cf49dc575c369028daae17a4dd398b69e000d"
  license "MIT"

  livecheck do
    url "https://www.jenkins.io/download/"
    regex(%r{href=.*?/war-stable/v?(\d+(?:\.\d+)+)/jenkins\.war}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "891b877d5baf0f0b33a57855a7d05df53ebae339795ed2d219e5b8bc3a5bb5e5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "891b877d5baf0f0b33a57855a7d05df53ebae339795ed2d219e5b8bc3a5bb5e5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "891b877d5baf0f0b33a57855a7d05df53ebae339795ed2d219e5b8bc3a5bb5e5"
    sha256 cellar: :any_skip_relocation, ventura:        "891b877d5baf0f0b33a57855a7d05df53ebae339795ed2d219e5b8bc3a5bb5e5"
    sha256 cellar: :any_skip_relocation, monterey:       "891b877d5baf0f0b33a57855a7d05df53ebae339795ed2d219e5b8bc3a5bb5e5"
    sha256 cellar: :any_skip_relocation, big_sur:        "891b877d5baf0f0b33a57855a7d05df53ebae339795ed2d219e5b8bc3a5bb5e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd6ace8a0b9970ab35ea5a8d5b6ab78c67ae693c2762617179b876fb843975eb"
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
