class Grails < Formula
  desc "Web application framework for the Groovy language"
  homepage "https://grails.apache.org/"
  url "https://github.com/apache/grails-core/releases/download/v7.2.2/apache-grails-7.2.2-bin.zip"
  sha256 "92e0f219cc975c797a1bd6ddc8b6f97bf73d22d7c6f0c108fc954519aa7f45f8"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0f1f4a47da1eec4f1d20c6b1067ab92ae5efac8d84ca2243c5e5e9ca1295b506"
  end

  depends_on "openjdk@21"

  def java_version
    "21"
  end

  def install
    # Remove Windows files
    rm Dir["bin/*.bat"]

    libexec.install Dir["*"]
    bin.install libexec.glob("bin/*")
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
