class Ivy < Formula
  desc "Agile dependency manager"
  homepage "https://ant.apache.org/ivy/"
  url "https://www.apache.org/dyn/closer.lua?path=ant/ivy/2.5.1/apache-ivy-2.5.1-bin.tar.gz"
  mirror "https://archive.apache.org/dist/ant/ivy/2.5.1/apache-ivy-2.5.1-bin.tar.gz"
  sha256 "ce9d3d5e37f6bc3c95a21efc94ae4ab73ec27b3e8d0d86515b44b562c4bb431e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "72bde283303b30c63dbd90af1cd59ed471d5b33c1856e5347d560f38ae8c09f2"
  end

  depends_on "openjdk"

  def install
    libexec.install Dir["ivy*"]
    doc.install Dir["doc/*"]
    bin.write_jar_script libexec/"ivy-#{version}.jar", "ivy", "$JAVA_OPTS"
  end
end
