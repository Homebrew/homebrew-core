class Jmeter < Formula
  desc "Load testing and performance measurement application"
  homepage "https://jmeter.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=jmeter/binaries/apache-jmeter-5.5.tgz"
  mirror "https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-5.5.tgz"
  sha256 "60e89c7c4523731467fdb717f33d614086c10f0316369cbaa45650ae1c402e1f"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "469626a586f678b34806c015702bb700ed837df7b0a1a939d21446e27ea95eed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "469626a586f678b34806c015702bb700ed837df7b0a1a939d21446e27ea95eed"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "469626a586f678b34806c015702bb700ed837df7b0a1a939d21446e27ea95eed"
    sha256 cellar: :any_skip_relocation, ventura:        "469626a586f678b34806c015702bb700ed837df7b0a1a939d21446e27ea95eed"
    sha256 cellar: :any_skip_relocation, monterey:       "469626a586f678b34806c015702bb700ed837df7b0a1a939d21446e27ea95eed"
    sha256 cellar: :any_skip_relocation, big_sur:        "469626a586f678b34806c015702bb700ed837df7b0a1a939d21446e27ea95eed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca9c9fb73567d2e499f983247d57f955a8a71044626aaffcc4ed4364d59610b8"
  end

  depends_on "openjdk@17"

  resource "jmeter-plugins-manager" do
    url "https://search.maven.org/remotecontent?filepath=kg/apc/jmeter-plugins-manager/1.7/jmeter-plugins-manager-1.7.jar"
    sha256 "2ae43743c5bc73d557e08e79fb9b137d301626bb393c2c03aa381b1dc8fc40ed"
  end

  def install
    # Remove windows files
    rm_f Dir["bin/*.bat"]
    prefix.install_metafiles
    libexec.install Dir["*"]
    (bin/"jmeter").write_env_script libexec/"bin/jmeter", JAVA_HOME: Formula["openjdk@17"].opt_prefix

    resource("jmeter-plugins-manager").stage do
      (libexec/"lib/ext").install Dir["*"]
    end
  end

  test do
    (testpath/"test.jmx").write <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <jmeterTestPlan version="1.2" properties="5.0" jmeter="5.5">
        <hashTree>
          <TestPlan guiclass="TestPlanGui" testclass="TestPlan" testname="Test Plan" enabled="true">
          </TestPlan>
          <hashTree>
            <ThreadGroup guiclass="ThreadGroupGui" testclass="ThreadGroup" testname="Thread Group" enabled="true">
              <stringProp name="ThreadGroup.on_sample_error">continue</stringProp>
              <elementProp name="ThreadGroup.main_controller" elementType="LoopController" guiclass="LoopControlPanel" testclass="LoopController" testname="Loop Controller" enabled="true">
                <boolProp name="LoopController.continue_forever">false</boolProp>
                <stringProp name="LoopController.loops">1</stringProp>
              </elementProp>
              <stringProp name="ThreadGroup.num_threads">1</stringProp>
            </ThreadGroup>
            <hashTree>
              <DebugSampler guiclass="TestBeanGUI" testclass="DebugSampler" testname="Debug Sampler" enabled="true">
              </DebugSampler>
              <hashTree>
                <JSR223PostProcessor guiclass="TestBeanGUI" testclass="JSR223PostProcessor" testname="JSR223 PostProcessor" enabled="true">
                  <stringProp name="cacheKey">true</stringProp>
                  <stringProp name="script">import java.util.Random
      Random rand = new Random();
      // This will break unless Groovy accepts the current version of the JDK
      int rand_int1 = rand.nextInt(1000);
      </stringProp>
                  <stringProp name="scriptLanguage">groovy</stringProp>
                </JSR223PostProcessor>
                <hashTree/>
              </hashTree>
            </hashTree>
          </hashTree>
        </hashTree>
      </jmeterTestPlan>
    EOS
    refute_match "Uncaught Exception", shell_output("#{bin}/jmeter -n -t test.jmx 2>&1")
  end
end
