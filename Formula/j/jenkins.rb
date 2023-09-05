class Jenkins < Formula
  desc "Extendable open source continuous integration server"
  homepage "https://www.jenkins.io/"
  url "https://get.jenkins.io/war/2.421/jenkins.war"
  sha256 "278c6d06aa0e59f4f019114011c9b4926e96f54747123a89a7bb2c1efb1c07a9"
  license "MIT"

  livecheck do
    url "https://www.jenkins.io/download/"
    regex(%r{href=.*?/war/v?(\d+(?:\.\d+)+)/jenkins\.war}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f95161f50b20db0a26f866673bf035b5ec5566dcf9a671b3700951cbc1e327e6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f95161f50b20db0a26f866673bf035b5ec5566dcf9a671b3700951cbc1e327e6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f95161f50b20db0a26f866673bf035b5ec5566dcf9a671b3700951cbc1e327e6"
    sha256 cellar: :any_skip_relocation, ventura:        "f95161f50b20db0a26f866673bf035b5ec5566dcf9a671b3700951cbc1e327e6"
    sha256 cellar: :any_skip_relocation, monterey:       "f95161f50b20db0a26f866673bf035b5ec5566dcf9a671b3700951cbc1e327e6"
    sha256 cellar: :any_skip_relocation, big_sur:        "f95161f50b20db0a26f866673bf035b5ec5566dcf9a671b3700951cbc1e327e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86f09b6121adfd3d2547da48dc4483c334aab9c4b4f677746e3fce88046a7fff"
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
