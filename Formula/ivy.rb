class Ivy < Formula
  desc "Agile dependency manager"
  homepage "https://ant.apache.org/ivy/"
  url "https://www.apache.org/dyn/closer.lua?path=ant/ivy/2.5.0/apache-ivy-2.5.0-bin.tar.gz"
  mirror "https://archive.apache.org/dist/ant/ivy/2.5.0/apache-ivy-2.5.0-bin.tar.gz"
  sha256 "3855a5769b5dbeafa9fb6a00f130467fd0f89da684a0b33a91e3dc5dae2715c7"

  bottle :unneeded

  def install
    libexec.install Dir["ivy*"]
    doc.install Dir["doc/*"]
    bin.write_jar_script libexec/"ivy-#{version}.jar", "ivy", "$JAVA_OPTS"
  end
end
