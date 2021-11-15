class Jmeter < Formula
  desc "Load testing and performance measurement application"
  homepage "https://jmeter.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=jmeter/binaries/apache-jmeter-5.4.1.tgz"
  mirror "https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-5.4.1.tgz"
  sha256 "4edae99881d1cdb5048987accbd02b3f3cdadea4a108d16d07fb1525ef612cf3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "511f09fb39543951f61dfd1ec75cefc91d86d181e4fcc016408bff5cffc8e860"
    sha256 cellar: :any_skip_relocation, big_sur:       "c0e2b8904f50831defb9c2cc948f6fc6591324d0e14db6e996cc5d0ba4c15867"
    sha256 cellar: :any_skip_relocation, catalina:      "d7aba96b31d80733d0e1cb760411465fd5d27780579c66f8218186c8bd412149"
    sha256 cellar: :any_skip_relocation, mojave:        "9d97d4aaae18b7001f0aba7db65f703e54c7fc90704fef283c3bacd5323b9735"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b0c5646ef5a285ef5c9d162aa3c6b1d804980a62a8213aa096f4889d56be888"
    sha256 cellar: :any_skip_relocation, all:           "5b0c5646ef5a285ef5c9d162aa3c6b1d804980a62a8213aa096f4889d56be888"
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
