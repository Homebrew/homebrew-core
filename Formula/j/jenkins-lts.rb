class JenkinsLts < Formula
  desc "Extendable open source continuous integration server"
  homepage "https://www.jenkins.io/"
  url "https://get.jenkins.io/war-stable/2.414.2/jenkins.war"
  sha256 "922bbf6269fddad614bb6540241ed0ce5523a4a5328229e15f5e7bb7ffd565b8"
  license "MIT"

  livecheck do
    url "https://www.jenkins.io/download/"
    regex(%r{href=.*?/war-stable/v?(\d+(?:\.\d+)+)/jenkins\.war}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3271a88fe7ca2471ad67518d27770c7f047c7960e5011041fa9e31f8a9b332fc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3271a88fe7ca2471ad67518d27770c7f047c7960e5011041fa9e31f8a9b332fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3271a88fe7ca2471ad67518d27770c7f047c7960e5011041fa9e31f8a9b332fc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3271a88fe7ca2471ad67518d27770c7f047c7960e5011041fa9e31f8a9b332fc"
    sha256 cellar: :any_skip_relocation, sonoma:         "3271a88fe7ca2471ad67518d27770c7f047c7960e5011041fa9e31f8a9b332fc"
    sha256 cellar: :any_skip_relocation, ventura:        "3271a88fe7ca2471ad67518d27770c7f047c7960e5011041fa9e31f8a9b332fc"
    sha256 cellar: :any_skip_relocation, monterey:       "3271a88fe7ca2471ad67518d27770c7f047c7960e5011041fa9e31f8a9b332fc"
    sha256 cellar: :any_skip_relocation, big_sur:        "3271a88fe7ca2471ad67518d27770c7f047c7960e5011041fa9e31f8a9b332fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae3c16e88c5232bcde493cca9d3af3208bcde9c0bc6d266b070a6da70b992741"
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
