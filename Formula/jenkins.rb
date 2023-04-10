class Jenkins < Formula
  desc "Extendable open source continuous integration server"
  homepage "https://www.jenkins.io/"
  url "https://get.jenkins.io/war/2.399/jenkins.war"
  sha256 "15de50b00d6a9613ddc78b617436cf7e54b6a2807d8d742953672c2c92210b2f"
  license "MIT"

  livecheck do
    url "https://www.jenkins.io/download/"
    regex(%r{href=.*?/war/v?(\d+(?:\.\d+)+)/jenkins\.war}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e4feb11008958d2e52cbc705b60336d5d96c39c3079498983f4dfba6c9b98e38"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e4feb11008958d2e52cbc705b60336d5d96c39c3079498983f4dfba6c9b98e38"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e4feb11008958d2e52cbc705b60336d5d96c39c3079498983f4dfba6c9b98e38"
    sha256 cellar: :any_skip_relocation, ventura:        "e4feb11008958d2e52cbc705b60336d5d96c39c3079498983f4dfba6c9b98e38"
    sha256 cellar: :any_skip_relocation, monterey:       "e4feb11008958d2e52cbc705b60336d5d96c39c3079498983f4dfba6c9b98e38"
    sha256 cellar: :any_skip_relocation, big_sur:        "e4feb11008958d2e52cbc705b60336d5d96c39c3079498983f4dfba6c9b98e38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d11baecd8a78dc0eadec26852eaaeca38d2b803ced07c17c1bbaf51c236e2760"
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
      To start the Jenkins service, run "brew services start jenkins"
      To restart the Jenkins service, run "brew services restart jenkins"
      To update the Jenkins version, run "brew upgrade jenkins"

      Take a look at the documentation, how to configure Jenkins:
      https://www.jenkins.io/doc/book/installing/macos/
     
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
