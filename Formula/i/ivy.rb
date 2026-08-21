class Ivy < Formula
  desc "Agile dependency manager"
  homepage "https://ant.apache.org/ivy/"
  url "https://www.apache.org/dyn/closer.lua?path=ant/ivy/2.6.0/apache-ivy-2.6.0-bin.tar.gz"
  mirror "https://archive.apache.org/dist/ant/ivy/2.6.0/apache-ivy-2.6.0-bin.tar.gz"
  sha256 "3ada1eaadfaddf5347f1de8303d283dc535f4d8bddd7bee7b32e397c8327cb1f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bf45fa90dd574a280c73748a8add44d6c3d1bcf11281d5459bda8d75df60531f"
  end

  depends_on "openjdk"

  def install
    libexec.install Dir["ivy*"]
    doc.install Dir["doc/*"]
    bin.write_jar_script libexec/"ivy-#{version}.jar", "ivy", "$JAVA_OPTS"
  end
end
