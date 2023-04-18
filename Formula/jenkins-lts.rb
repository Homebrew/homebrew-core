class JenkinsLts < Formula
  desc "Extendable open source continuous integration server"
  homepage "https://www.jenkins.io/"
  url "https://get.jenkins.io/war-stable/2.387.2/jenkins.war"
  sha256 "5e39cb06d9b9eb18a3218b45a07c6bbb801fb353b774eb5bf7749f891b500ca9"
  license "MIT"

  livecheck do
    url "https://www.jenkins.io/download/"
    regex(%r{href=.*?/war-stable/v?(\d+(?:\.\d+)+)/jenkins\.war}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ccd7c25adb50d5ace7cab397883c53193cbef897c24e0f4b394939385f7baa4f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ccd7c25adb50d5ace7cab397883c53193cbef897c24e0f4b394939385f7baa4f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ccd7c25adb50d5ace7cab397883c53193cbef897c24e0f4b394939385f7baa4f"
    sha256 cellar: :any_skip_relocation, ventura:        "ccd7c25adb50d5ace7cab397883c53193cbef897c24e0f4b394939385f7baa4f"
    sha256 cellar: :any_skip_relocation, monterey:       "ccd7c25adb50d5ace7cab397883c53193cbef897c24e0f4b394939385f7baa4f"
    sha256 cellar: :any_skip_relocation, big_sur:        "ccd7c25adb50d5ace7cab397883c53193cbef897c24e0f4b394939385f7baa4f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "14985d90c61b4772d2730c7bc4ec7564537da2288e0a24e5b281cf62fccd0681"
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
