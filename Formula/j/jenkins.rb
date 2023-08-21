class Jenkins < Formula
  desc "Extendable open source continuous integration server"
  homepage "https://www.jenkins.io/"
  url "https://get.jenkins.io/war/2.419/jenkins.war"
  sha256 "895a90dd5929a38c8cc8c0342478d27a6e01470cd7e8da8c4ae51f26aa1bdf85"
  license "MIT"

  livecheck do
    url "https://www.jenkins.io/download/"
    regex(%r{href=.*?/war/v?(\d+(?:\.\d+)+)/jenkins\.war}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f481799c352c61bc3f483c0b2a82614d06a8d5058936cead3dfd3428b5a2f505"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f481799c352c61bc3f483c0b2a82614d06a8d5058936cead3dfd3428b5a2f505"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f481799c352c61bc3f483c0b2a82614d06a8d5058936cead3dfd3428b5a2f505"
    sha256 cellar: :any_skip_relocation, ventura:        "f481799c352c61bc3f483c0b2a82614d06a8d5058936cead3dfd3428b5a2f505"
    sha256 cellar: :any_skip_relocation, monterey:       "f481799c352c61bc3f483c0b2a82614d06a8d5058936cead3dfd3428b5a2f505"
    sha256 cellar: :any_skip_relocation, big_sur:        "f481799c352c61bc3f483c0b2a82614d06a8d5058936cead3dfd3428b5a2f505"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b357f0ee192166394fbe23e1b0bec805dbf9dffca5ae1a8760cc1a032dc9e8bb"
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
