class Grails < Formula
  desc "Web application framework for the Groovy language"
  homepage "https://grails.apache.org/"
  url "https://github.com/apache/grails-core/releases/download/v7.0.3/apache-grails-7.0.3-bin.zip"
  sha256 "5ba5d30f3df4d6885fee9f0391dec8853b43cc6202fc0abf5d1d4c48b0f6aa9b"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ae4fe06d6bf236c105ea681778bbc3ab9632265a78fc38e3540ba03d86844e53"
  end

  depends_on "openjdk@21"

  def java_version
    "21"
  end

  def install
    # Remove Windows files
    rm Dir["bin/*.bat"]

    libexec.install Dir["*"]
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files libexec/"bin", Language::Java.java_home_env(java_version)
  end

  def caveats
    <<~EOS
      The GRAILS_HOME directory is:
        #{opt_libexec}
    EOS
  end

  test do
    assert_match "Grails Version: #{version}", shell_output("#{bin}/grails --version")

    system bin/"grails", "create-app", "brew-test"
    assert_path_exists testpath/"brew-test/gradle.properties"
    assert_match "brew.test", File.read(testpath/"brew-test/build.gradle")

    cd "brew-test" do
      system bin/"grails", "create-controller", "greeting"
      rm "grails-app/controllers/brew/test/GreetingController.groovy"
      Pathname("grails-app/controllers/brew/test/GreetingController.groovy").write <<~GROOVY
        package brew.test
        class GreetingController {
            def index() {
                render "Hello Homebrew"
            }
        }
      GROOVY

      # Test that scripts are compatible with OpenJDK version
      port = free_port
      ENV["JAVA_HOME"] = Language::Java.java_home(java_version)
      system "./gradlew", "--no-daemon", "assemble"
      pid = spawn "./gradlew", "--no-daemon", "bootRun", "-Dgrails.server.port=#{port}"
      begin
        sleep 20
        sleep 20 if OS.mac? && Hardware::CPU.intel?
        assert_equal "Hello Homebrew", shell_output("curl --silent http://localhost:#{port}/greeting/index")
      ensure
        Process.kill "TERM", pid
        Process.wait pid
      end
    end
  end
end
