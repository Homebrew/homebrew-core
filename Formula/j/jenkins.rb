class Jenkins < Formula
  desc "Extendable open source continuous integration server"
  homepage "https://www.jenkins.io/"
  url "https://get.jenkins.io/war/2.457/jenkins.war"
  sha256 "e4f1f086d183959347303bc7f17b4262fb0c5dcddaae5ae799e4ecbfd54eb80f"
  license "MIT"

  livecheck do
    url "https://www.jenkins.io/download/"
    regex(%r{href=.*?/war/v?(\d+(?:\.\d+)+)/jenkins\.war}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "64410be95a9df1435ceb837f7b615198578c06bfc885ed18413377c4aef0f18c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8f5a4e8e3225b132932d8f8a6a26e3df22bfbbe6b8c7f44f7dc82df53bf22b6a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "db4a6038a822ceee53b0fba57dedbc4265f57c13975d2029c2b60b3fbf98f13b"
    sha256 cellar: :any_skip_relocation, sonoma:         "ff401e827b566361c3ca442e713c1741d36f12e9919b34a5569814001a072ba3"
    sha256 cellar: :any_skip_relocation, ventura:        "46c23f00a12703c67fb8008156eaceea78fa93bf5f89ee3a1df289973fb0ad66"
    sha256 cellar: :any_skip_relocation, monterey:       "a9887c973a9e79e36a6cd13d961d280d88f496dce7fb6c61c9f35b5de870f55d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4691a488d523e41f14e7237933dd8690829bccb5ada2a80c7cc851651417fb5"
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
