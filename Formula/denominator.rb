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

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4302cca31698aae139610d5e8f0dbd281b1956a8a667d45571506c0f499721ca"
  end

  depends_on "openjdk"

  def install
    (libexec/"bin").install "denominator-cli-#{version}-fat.jar"
    bin.write_jar_script libexec/"bin/denominator-cli-#{version}-fat.jar", "denominator"
  end

  test do
    system "#{bin}/denominator", "providers"
  end
end
