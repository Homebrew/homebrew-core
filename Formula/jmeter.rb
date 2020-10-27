class Jmeter < Formula
  desc "Load testing and performance measurement application"
  homepage "https://jmeter.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=jmeter/binaries/apache-jmeter-5.3.tgz"
  mirror "https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-5.3.tgz"
  sha256 "d0611b46268c4e24220fed56e76d770077713ff863665c271ed6521046f2f0d0"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "e3f6544d4e7485525fa4cf8fd377f00ce7f7350fdbeeb1cfaba3b9539a6c1a88" => :catalina
    sha256 "e3f6544d4e7485525fa4cf8fd377f00ce7f7350fdbeeb1cfaba3b9539a6c1a88" => :mojave
    sha256 "e3f6544d4e7485525fa4cf8fd377f00ce7f7350fdbeeb1cfaba3b9539a6c1a88" => :high_sierra
  end

  resource "jmeter-plugins-manager" do
    url "https://search.maven.org/remotecontent?filepath=kg/apc/jmeter-plugins-manager/1.3/jmeter-plugins-manager-1.3.jar"
    sha256 "482b8a9cd82a69ef1b633fc4235bfa9bee96894f663e5085df7061410d6ab99a"
  end

  def install
    # Remove windows files
    rm_f Dir["bin/*.bat"]
    prefix.install_metafiles
    libexec.install Dir["*"]
    bin.write_exec_script libexec/"bin/jmeter"

    resource("jmeter-plugins-manager").stage do
      (libexec/"lib/ext").install Dir["*"]
    end
  end

  test do
    system "#{bin}/jmeter", "--version"
  end
end
