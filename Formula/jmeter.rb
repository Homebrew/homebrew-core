class Jmeter < Formula
  desc "Load testing and performance measurement application"
  homepage "https://jmeter.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=jmeter/binaries/apache-jmeter-5.1.1.tgz"
  sha256 "844d510fe04aaf62269311f18117d75c959148bb9f0fc76b4047abc8a8edb4ae"

  bottle do
    cellar :any
    sha256 "4afcc5dfc146762b68797bf13ac505ebdcd68ce4618e08967c14a5c42db99d7c" => :catalina
    sha256 "75fe29e4b60b96e881c3b64475d4f7fc268cd405e300b31f1aa3ce6cb26c4211" => :mojave
    sha256 "75fe29e4b60b96e881c3b64475d4f7fc268cd405e300b31f1aa3ce6cb26c4211" => :high_sierra
    sha256 "274d7e74800d66ef6e40938b0ab956a5cf541e8f11099c4eab08b5b734c0efdb" => :sierra
  end

  resource "jmeterplugins-standard" do
    url "https://jmeter-plugins.org/downloads/file/JMeterPlugins-Standard-1.4.0.zip"
    sha256 "3f740bb9b9a7120ed72548071cd46a5f92929e1ab196acc1b2548549090a2148"
  end

  resource "serveragent" do
    url "https://jmeter-plugins.org/downloads/file/ServerAgent-2.2.1.zip"
    sha256 "2d5cfd6d579acfb89bf16b0cbce01c8817cba52ab99b3fca937776a72a8f95ec"
  end

  resource "jmeterplugins-extras" do
    url "https://jmeter-plugins.org/downloads/file/JMeterPlugins-Extras-1.4.0.zip"
    sha256 "de35e653250882268aa24d011ec0f2afbc13e1c552fbb676c67515bc80ef3194"
  end

  resource "jmeterplugins-extraslibs" do
    url "https://jmeter-plugins.org/downloads/file/JMeterPlugins-ExtrasLibs-1.4.0.zip"
    sha256 "81d600a5bda6fdb362573d55c11208b2635728a2c18b7f647b9c7413c0f33ef3"
  end

  resource "jmeterplugins-webdriver" do
    url "https://jmeter-plugins.org/downloads/file/JMeterPlugins-WebDriver-1.4.0.zip"
    sha256 "521c2f7d452a84099407534bd50f29fd3761aa8a5beca52966bb9731e33b03e2"
  end

  resource "jmeterplugins-hadoop" do
    url "https://jmeter-plugins.org/downloads/file/JMeterPlugins-Hadoop-1.4.0.zip"
    sha256 "93030738d613748a685764fbfff0fe00ad2e161f2b72df6365294adc88db09b4"
  end

  def install
    # Remove windows files
    rm_f Dir["bin/*.bat"]
    prefix.install_metafiles
    libexec.install Dir["*"]
    bin.write_exec_script libexec/"bin/jmeter"

    resource("jmeterplugins-standard").stage do
      rm_f Dir["lib/ext/*.bat"]
      (libexec/"lib/ext").install Dir["lib/ext/*"]
      (libexec/"licenses/plugins/standard").install "LICENSE", "README"
    end
    resource("serveragent").stage do
      rm_f Dir["*.bat"]
      rm_f Dir["lib/*winnt*"]
      rm_f Dir["lib/*solaris*"]
      rm_f Dir["lib/*aix*"]
      rm_f Dir["lib/*hpux*"]
      rm_f Dir["lib/*linux*"]
      rm_f Dir["lib/*freebsd*"]
      (libexec/"serveragent").install Dir["*"]
    end
    resource("jmeterplugins-extras").stage do
      (libexec/"lib/ext").install Dir["lib/ext/*.jar"]
      (libexec/"licenses/plugins/extras").install "LICENSE", "README"
    end
    resource("jmeterplugins-extraslibs").stage do
      (libexec/"lib/ext").install Dir["lib/ext/*.jar"]
      (libexec/"lib").install Dir["lib/*.jar"]
      (libexec/"licenses/plugins/extras").install "LICENSE", "README"
    end
    resource("jmeterplugins-webdriver").stage do
      (libexec/"lib/ext").install Dir["lib/ext/*.jar"]
      (libexec/"lib").install Dir["lib/*.jar"]
      (libexec/"licenses/plugins/extras").install "LICENSE", "README"
    end
    resource("jmeterplugins-hadoop").stage do
      (libexec/"lib/ext").install Dir["lib/ext/*.jar"]
      (libexec/"lib").install Dir["lib/*.jar"]
      (libexec/"licenses/plugins/extras").install "LICENSE", "README", "NOTICE"
    end
  end

  test do
    system "#{bin}/jmeter", "--version"
  end
end
