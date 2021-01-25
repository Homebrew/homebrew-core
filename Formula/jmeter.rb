class Jmeter < Formula
  desc "Load testing and performance measurement application"
  homepage "https://jmeter.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=jmeter/binaries/apache-jmeter-5.4.1.tgz"
  mirror "https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-5.4.1.tgz"
  sha256 "4edae99881d1cdb5048987accbd02b3f3cdadea4a108d16d07fb1525ef612cf3"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "c0e2b8904f50831defb9c2cc948f6fc6591324d0e14db6e996cc5d0ba4c15867" => :big_sur
    sha256 "511f09fb39543951f61dfd1ec75cefc91d86d181e4fcc016408bff5cffc8e860" => :arm64_big_sur
    sha256 "d7aba96b31d80733d0e1cb760411465fd5d27780579c66f8218186c8bd412149" => :catalina
    sha256 "9d97d4aaae18b7001f0aba7db65f703e54c7fc90704fef283c3bacd5323b9735" => :mojave
  end

  depends_on "openjdk"

  resource "jmeter-plugins-manager" do
    url "https://search.maven.org/remotecontent?filepath=kg/apc/jmeter-plugins-manager/1.6/jmeter-plugins-manager-1.6.jar"
    sha256 "6f391eb6c935bd63ff9e356fb5f353d3c80b27bb762fcb5ce2c0c88f71fbd514"
  end

  def install
    # Remove windows files
    rm_f Dir["bin/*.bat"]
    prefix.install_metafiles
    libexec.install Dir["*"]
    (bin/"jmeter").write_env_script libexec/"bin/jmeter", JAVA_HOME: Formula["openjdk"].opt_prefix

    resource("jmeter-plugins-manager").stage do
      (libexec/"lib/ext").install Dir["*"]
    end
  end

  test do
    system "#{bin}/jmeter", "--version"
  end
end
