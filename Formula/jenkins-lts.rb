class JenkinsLts < Formula
  desc "Extendable open source continuous integration server"
  homepage "https://www.jenkins.io/"
  url "https://get.jenkins.io/war-stable/2.387.1/jenkins.war"
  sha256 "c132a1e00b685afc7996eba530be428a3279c649399417f9fa38fcbc0dbec027"
  license "MIT"

  livecheck do
    url "https://www.jenkins.io/download/"
    regex(%r{href=.*?/war-stable/v?(\d+(?:\.\d+)+)/jenkins\.war}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4f115837b5ffc654a1e7fa98eec5bae4bb39ecaf22b88b390a9fa783f436faee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6ec4747019bdc47167a275f532f8f6b3cc0bf945c6e69725a78dc0f480a3a709"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "851a94ee075938fa9e34ace4a26e1d85ee1d28ef977662c1e265df6894b31ea5"
    sha256 cellar: :any_skip_relocation, ventura:        "da924c9147e10fb6563dbb95f42fea930d210d440218e89be6e92f8701e5f256"
    sha256 cellar: :any_skip_relocation, monterey:       "5cee0de1dc101d5d2a36306eb4d88420e2610ca25b7f6882afe56f778ec135f2"
    sha256 cellar: :any_skip_relocation, big_sur:        "57fbb45ceee97139f20f50f88f511c09a492dd9a5fc2ddaf8716493557a0c47b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c3593f6b1af7a25acdfe7676bd2de8add0aad21b21a0748913db72aea878fac"
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
