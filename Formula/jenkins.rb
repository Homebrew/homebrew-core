class Jenkins < Formula
  desc "Extendable open source continuous integration server"
  homepage "https://www.jenkins.io/"
  url "https://get.jenkins.io/war/2.391/jenkins.war"
  sha256 "676fcdf8f7f61bdcb86df203f7ad05ef5fddb6353542f164035c8d7116af9819"
  license "MIT"

  livecheck do
    url "https://www.jenkins.io/download/"
    regex(%r{href=.*?/war/v?(\d+(?:\.\d+)+)/jenkins\.war}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5fc229cd2a942f9bedf5dc5c88823d9e6b3be2b18cd57b078172a5e4fff27244"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f817fb8afa907676ec059c511fe62a989d126c07bc8664f05e3ffe04be1219fd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f817fb8afa907676ec059c511fe62a989d126c07bc8664f05e3ffe04be1219fd"
    sha256 cellar: :any_skip_relocation, ventura:        "252d1920f6ed6e5c073560f721b1408c19a1ed5f85ff37543af7558e5214f0b3"
    sha256 cellar: :any_skip_relocation, monterey:       "b15a9436560315cdd15d143c033c841cbbc668feeb148e9a635a510afa3783a8"
    sha256 cellar: :any_skip_relocation, big_sur:        "e52110704e460bc690bf15580d9900ac472bb9acbfcc84d159009bbdf8b451fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d44cf25dbe44e2ba4dc0ce8f673a2be12338197586dd3013f5eb6a9dd868550"
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
