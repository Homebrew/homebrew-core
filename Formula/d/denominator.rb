class Denominator < Formula
  desc "Portable Java library for manipulating DNS clouds"
  homepage "https://github.com/Netflix/denominator/tree/v4.7.1/cli"
  url "https://search.maven.org/remotecontent?filepath=com/netflix/denominator/denominator-cli/4.7.1/denominator-cli-4.7.1-fat.jar"
  sha256 "f2d09aaebb63ccb348dcba3a5cc3e94a42b0eae49e90ac0ec2b0a14adfbe5254"
  license "Apache-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=com/netflix/denominator/denominator-cli/maven-metadata.xml"
    regex(%r{<version>v?(\d+(?:\.\d+)+)</version>}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "3da7d5704460e94f75bd1241c7d285971b2c22f23633c2cea058cccefc6a65e5"
  end

  depends_on "openjdk"

  def install
    (libexec/"bin").install "denominator-cli-#{version}-fat.jar"
    bin.write_jar_script libexec/"bin/denominator-cli-#{version}-fat.jar", "denominator"
  end

  test do
    system bin/"denominator", "providers"
  end
end
