class Jenkins < Formula
  desc "Extendable open source continuous integration server"
  homepage "https://www.jenkins.io/"
  url "https://get.jenkins.io/war/2.406/jenkins.war"
  sha256 "9a1872f6a297961feeb34c62b8759878d1afeab09749766f6c909e59e73a6a04"
  license "MIT"

  livecheck do
    url "https://www.jenkins.io/download/"
    regex(%r{href=.*?/war/v?(\d+(?:\.\d+)+)/jenkins\.war}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "daa75a71f80ddcb706fa7f0f3316a2d59454c4692288a37845a29db3d986d32a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "daa75a71f80ddcb706fa7f0f3316a2d59454c4692288a37845a29db3d986d32a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "daa75a71f80ddcb706fa7f0f3316a2d59454c4692288a37845a29db3d986d32a"
    sha256 cellar: :any_skip_relocation, ventura:        "daa75a71f80ddcb706fa7f0f3316a2d59454c4692288a37845a29db3d986d32a"
    sha256 cellar: :any_skip_relocation, monterey:       "daa75a71f80ddcb706fa7f0f3316a2d59454c4692288a37845a29db3d986d32a"
    sha256 cellar: :any_skip_relocation, big_sur:        "daa75a71f80ddcb706fa7f0f3316a2d59454c4692288a37845a29db3d986d32a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f3d83bbc8aa8ffa380d20e2e93d7b53c4a88523c3f49f7ae516c8b77d25348e2"
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
