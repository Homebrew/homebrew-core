class OrcTools < Formula
  desc "ORC java command-line tools and utilities"
  homepage "https://orc.apache.org/"
  url "https://search.maven.org/remotecontent?filepath=org/apache/orc/orc-tools/2.3.1/orc-tools-2.3.1-uber.jar"
  sha256 "05110c26350d384da0315291b13490a1aa4879d8b80af1d1117fd072d46bdff0"
  license "Apache-2.0"

  livecheck do
    url "https://search.maven.org/remotecontent?filepath=org/apache/orc/orc-tools/"
    regex(%r{href=["']?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e81a7d37e5eb942b1b4c41d9df99c036bddc80c333c383799d8d39897c8a2c07"
  end

  depends_on "openjdk"

  def install
    libexec.install "orc-tools-#{version}-uber.jar"
    bin.write_jar_script libexec/"orc-tools-#{version}-uber.jar", "orc-tools"
  end

  test do
    system bin/"orc-tools", "meta", "-h"
  end
end
