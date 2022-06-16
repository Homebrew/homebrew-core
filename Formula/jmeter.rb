class Jmeter < Formula
  desc "Load testing and performance measurement application"
  homepage "https://jmeter.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=jmeter/binaries/apache-jmeter-5.5.tgz"
  mirror "https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-5.5.tgz"
  sha256 "60e89c7c4523731467fdb717f33d614086c10f0316369cbaa45650ae1c402e1f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ad4c2d2fd4fe481f9443824e6555240d68b26bd01a7ce8444f755fe20f32e51e"
  end

  depends_on "openjdk"

  resource "jmeter-plugins-manager" do
    url "https://search.maven.org/remotecontent?filepath=kg/apc/jmeter-plugins-manager/1.7/jmeter-plugins-manager-1.7.jar"
    sha256 "2ae43743c5bc73d557e08e79fb9b137d301626bb393c2c03aa381b1dc8fc40ed"
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
