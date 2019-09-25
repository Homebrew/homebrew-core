class OrcTools < Formula
  desc "ORC java command-line tools and utilities"
  homepage "https://orc.apache.org/"
  url "https://search.maven.org/remotecontent?filepath=org/apache/orc/orc-tools/1.6.0/orc-tools-1.6.0-uber.jar"
  sha256 "573a61901d520649cf92797f20088f37aa12fa29adb8a34b89dc10263ddda62d"

  bottle :unneeded

  def install
    libexec.install "orc-tools-#{version}-uber.jar"
    bin.write_jar_script libexec/"orc-tools-#{version}-uber.jar", "orc-tools"
  end

  test do
    system "#{bin}/orc-tools", "meta", "-h"
  end
end
