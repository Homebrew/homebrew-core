class Jenkins < Formula
  desc "Extendable open source continuous integration server"
  homepage "https://jenkins.io/"
  url "http://mirrors.jenkins.io/war/2.306/jenkins.war"
  sha256 "51663780626a80134c0970ad6b6f9e0000c8772b0e1e3b452a902809b7f7288e"
  license "MIT"

  livecheck do
    url "https://www.jenkins.io/download/"
    regex(%r{href=.*?/war/v?(\d+(?:\.\d+)+)/jenkins\.war}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "10e957d0b23a52b4967056fe46c1b76b3f73b84725f785f9e721ae208086b0c5"
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
