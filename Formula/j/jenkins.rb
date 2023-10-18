class Jenkins < Formula
  desc "Extendable open source continuous integration server"
  homepage "https://www.jenkins.io/"
  url "https://get.jenkins.io/war/2.428/jenkins.war"
  sha256 "b4f596923eb37b93c3f5a21a6a32fc3bedd57d04a1b63186811c0ce8b3d9f07c"
  license "MIT"

  livecheck do
    url "https://www.jenkins.io/download/"
    regex(%r{href=.*?/war/v?(\d+(?:\.\d+)+)/jenkins\.war}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "88e8810652aea07c8e7d6c1b868e8c4a820cae08e10ebedd3a36e799e598077e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "88e8810652aea07c8e7d6c1b868e8c4a820cae08e10ebedd3a36e799e598077e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "88e8810652aea07c8e7d6c1b868e8c4a820cae08e10ebedd3a36e799e598077e"
    sha256 cellar: :any_skip_relocation, sonoma:         "88e8810652aea07c8e7d6c1b868e8c4a820cae08e10ebedd3a36e799e598077e"
    sha256 cellar: :any_skip_relocation, ventura:        "88e8810652aea07c8e7d6c1b868e8c4a820cae08e10ebedd3a36e799e598077e"
    sha256 cellar: :any_skip_relocation, monterey:       "88e8810652aea07c8e7d6c1b868e8c4a820cae08e10ebedd3a36e799e598077e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d476f59c4cc5c43749e394c1cbcdc02285e04e56ed04a4789990b250733fba10"
  end

  head do
    url "https://github.com/jenkinsci/jenkins.git", branch: "master"
    depends_on "maven" => :build
  end

  depends_on "openjdk"

  def install
    if build.head?
      system "mvn", "clean", "install", "-pl", "war", "-am", "-DskipTests"
    else
      system "#{Formula["openjdk"].opt_bin}/jar", "xvf", "jenkins.war"
    end
    libexec.install Dir["**/jenkins.war", "**/cli-#{version}.jar"]
    bin.write_jar_script libexec/"jenkins.war", "jenkins"
    bin.write_jar_script libexec/"cli-#{version}.jar", "jenkins-cli"

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
