class Ivy < Formula
  desc "Agile dependency manager"
  homepage "https://ant.apache.org/ivy/"
  url "https://www.apache.org/dyn/closer.cgi?path=ant/ivy/2.5.0-rc1/apache-ivy-2.5.0-rc1-bin.tar.gz"
  sha256 "7fe2a21c5208c8db23698eb06bd5c681e7c0f208d96879df2317e94262931362"

  bottle :unneeded

  def install
    libexec.install Dir["ivy*"]
    doc.install Dir["doc/*"]
    bin.write_jar_script libexec/"ivy-#{version}.jar", "ivy", "$JAVA_OPTS"
  end
end
