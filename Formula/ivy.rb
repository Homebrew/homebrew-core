class Ivy < Formula
  desc "Agile dependency manager"
  homepage "https://ant.apache.org/ivy/"
  url "https://www.apache.org/dyn/closer.lua?path=ant/ivy/2.5.0/apache-ivy-2.5.0-bin.tar.gz"
  mirror "https://archive.apache.org/dist/ant/ivy/2.5.0/apache-ivy-2.5.0-bin.tar.gz"
  sha256 "3855a5769b5dbeafa9fb6a00f130467fd0f89da684a0b33a91e3dc5dae2715c7"
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
