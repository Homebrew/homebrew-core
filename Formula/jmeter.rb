class Jmeter < Formula
  desc "Load testing and performance measurement application"
  homepage "https://jmeter.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=jmeter/binaries/apache-jmeter-5.4.tgz"
  mirror "https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-5.4.tgz"
  sha256 "2a900f56f106af5f165f408b61988a5fbde2b3c6dc5e7e9ccedbed0c01dc7ec1"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "b1ad4759a899c7c874774eda290a49e43d2d98fb5a04ee8b3ba6035587a019cd" => :big_sur
    sha256 "d0d16fa9b777f63eb8bea56de7eb9a2d06a2e7e2df2f95002e65a849975cda9d" => :arm64_big_sur
    sha256 "68fadfae2c4b129fe86504504ab980b942937ce0b66dba6dbd716846796f5262" => :catalina
    sha256 "93a53dce5bd7d8a7dd8e6f51905e7c4c38db9c0965eee022925cc1166ea672ca" => :mojave
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
