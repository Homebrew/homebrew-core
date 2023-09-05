class Ivy < Formula
  desc "Agile dependency manager"
  homepage "https://ant.apache.org/ivy/"
  url "https://www.apache.org/dyn/closer.lua?path=ant/ivy/2.5.2/apache-ivy-2.5.2-bin.tar.gz"
  mirror "https://archive.apache.org/dist/ant/ivy/2.5.2/apache-ivy-2.5.2-bin.tar.gz"
  sha256 "c673ad3a8b09935c1a0cee8551fb6fd9eb7b0cf3b5e5104047af478ef60517a2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "803cdd933fe5396b49bd0b04ac3470f0761a6462bb1ac29acefb7e18847d923a"
  end

  depends_on "openjdk"

  def install
    libexec.install Dir["ivy*"]
    doc.install Dir["doc/*"]
    bin.write_jar_script libexec/"ivy-#{version}.jar", "ivy", "$JAVA_OPTS"
  end
end
