class Jmeter < Formula
  desc "Load testing and performance measurement application"
  homepage "https://jmeter.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=jmeter/binaries/apache-jmeter-5.6.3.tgz"
  mirror "https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-5.6.3.tgz"
  sha256 "f68efc17fe060f698c48a6abe2599a933927486bda2924dbe14c74895318ddde"
  license "Apache-2.0"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "13c89a34f46a525ba7131741a8c7c8f0ea789ed231762b20ac6e5dc5f0757b04"
  end

  depends_on "openjdk@21"

  resource "jmeter-plugins-manager" do
    url "https://search.maven.org/remotecontent?filepath=kg/apc/jmeter-plugins-manager/1.9/jmeter-plugins-manager-1.9.jar"
    sha256 "b74ea9f498ec90cb48ea2de4c19b71007f2b33a9c2808febaf7c32b35412c13d"
  end

  def install
    # Remove windows files
    rm(Dir["bin/*.bat"])

    libexec.install Dir["*"]
    (bin/"jmeter").write_env_script libexec/"bin/jmeter", JAVA_HOME: Formula["openjdk@21"].opt_prefix

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
