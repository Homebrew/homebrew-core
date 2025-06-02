class Grails < Formula
  desc "Web application framework for the Groovy language"
  homepage "https://grails.org"
  url "https://github.com/grails/grails-core/releases/download/v6.2.3/grails-6.2.3.zip"
  sha256 "b41e95efad66e2b93b4e26664f746a409ea70d43548e6c011e9695874a710b09"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e3e2858977f849082460aa6a92b6ad8f702a55663df1c8a48dcbfdbe9c524560"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e3e2858977f849082460aa6a92b6ad8f702a55663df1c8a48dcbfdbe9c524560"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e3e2858977f849082460aa6a92b6ad8f702a55663df1c8a48dcbfdbe9c524560"
    sha256 cellar: :any_skip_relocation, sonoma:        "6d99581afd8f11f9c5064cc312865fc0d6fe2ec04a20035c02f47add859c2ae8"
    sha256 cellar: :any_skip_relocation, ventura:       "6d99581afd8f11f9c5064cc312865fc0d6fe2ec04a20035c02f47add859c2ae8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0d496d2a0d69e0670260bf7b187668e2ac4ee292363a85eee8f1c5583674124d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3e2858977f849082460aa6a92b6ad8f702a55663df1c8a48dcbfdbe9c524560"
  end

  depends_on "openjdk@17"

  resource "cli" do
    url "https://github.com/grails/grails-forge/releases/download/v6.2.3/grails-cli-6.2.3.zip"
    sha256 "ef78a48238629a89d64996367d0424bc872978caf6c23c3cdae92b106e2b1731"

    livecheck do
      formula :parent
    end
  end

  def java_version
    "17"
  end

  def install
    odie "cli resource needs to be updated" if version != resource("cli").version

    libexec.install Dir["*"]

    resource("cli").stage do
      rm("bin/grails.bat")
      (libexec/"lib").install Dir["lib/*.jar"]
      bin.install "bin/grails"
      bash_completion.install "bin/grails_completion" => "grails"
    end

    bin.env_script_all_files libexec/"bin", Language::Java.overridable_java_home_env(java_version)
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
        assert_equal "Hello Homebrew", shell_output("curl --silent http://localhost:#{port}/greeting/index")
      ensure
        Process.kill "TERM", pid
        Process.wait pid
      end
    end
  end
end
