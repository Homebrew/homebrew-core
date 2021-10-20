class Jenkins < Formula
  desc "Extendable open source continuous integration server"
  homepage "https://www.jenkins.io/"
  url "https://get.jenkins.io/war/2.316/jenkins.war"
  sha256 "4128e1d9ea5a541ba620a8e94a43010694ca11fdefa9881702f934d2c2c0b970"
  license "MIT"

  livecheck do
    url "https://www.jenkins.io/download/"
    regex(%r{href=.*?/war/v?(\d+(?:\.\d+)+)/jenkins\.war}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5fd3b48efeafc07c964e66cf970e881b7d78304ef863f7a91f726ab952fef981"
    sha256 cellar: :any_skip_relocation, big_sur:       "5fd3b48efeafc07c964e66cf970e881b7d78304ef863f7a91f726ab952fef981"
    sha256 cellar: :any_skip_relocation, catalina:      "5fd3b48efeafc07c964e66cf970e881b7d78304ef863f7a91f726ab952fef981"
    sha256 cellar: :any_skip_relocation, mojave:        "5fd3b48efeafc07c964e66cf970e881b7d78304ef863f7a91f726ab952fef981"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c47134ef105af8404e42cd867965cf7d630fa3997370d69397b88d45c5f52453"
  end

  head do
    url "https://github.com/jenkinsci/jenkins.git"
    depends_on "maven" => :build
  end

  depends_on "openjdk@11"

  def install
    if build.head?
      system "mvn", "clean", "install", "-pl", "war", "-am", "-DskipTests"
    else
      system "#{Formula["openjdk@11"].opt_bin}/jar", "xvf", "jenkins.war"
    end
    libexec.install Dir["**/jenkins.war", "**/cli-#{version}.jar"]
    bin.write_jar_script libexec/"jenkins.war", "jenkins", java_version: "11"
    bin.write_jar_script libexec/"cli-#{version}.jar", "jenkins-cli", java_version: "11"
  end

  def caveats
    <<~EOS
      Note: When using launchctl the port will be 8080.
    EOS
  end

  service do
    run [Formula["openjdk@11"].opt_bin/"java", "-Dmail.smtp.starttls.enable=true", "-jar", opt_libexec/"jenkins.war",
         "--httpListenAddress=127.0.0.1", "--httpPort=8080"]
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
