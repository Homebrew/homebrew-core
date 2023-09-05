class JenkinsLts < Formula
  desc "Extendable open source continuous integration server"
  homepage "https://www.jenkins.io/"
  url "https://get.jenkins.io/war-stable/2.414.1/jenkins.war"
  sha256 "f2523f9b5fe50199f68f60f96b6bef9ca100e18099e3e3da7a9a49ae8c47b015"
  license "MIT"

  livecheck do
    url "https://www.jenkins.io/download/"
    regex(%r{href=.*?/war-stable/v?(\d+(?:\.\d+)+)/jenkins\.war}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a3e44923ab843fb02c81c7c41f8a8772ba6348a95c5eb6c0b788b9c2692289f4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a3e44923ab843fb02c81c7c41f8a8772ba6348a95c5eb6c0b788b9c2692289f4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a3e44923ab843fb02c81c7c41f8a8772ba6348a95c5eb6c0b788b9c2692289f4"
    sha256 cellar: :any_skip_relocation, ventura:        "a3e44923ab843fb02c81c7c41f8a8772ba6348a95c5eb6c0b788b9c2692289f4"
    sha256 cellar: :any_skip_relocation, monterey:       "a3e44923ab843fb02c81c7c41f8a8772ba6348a95c5eb6c0b788b9c2692289f4"
    sha256 cellar: :any_skip_relocation, big_sur:        "a3e44923ab843fb02c81c7c41f8a8772ba6348a95c5eb6c0b788b9c2692289f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6535c56445a2efe9b673a37e5a30b96bedb7f59917d04b1cae693534e2a0033"
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
