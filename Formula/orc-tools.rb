class OrcTools < Formula
  desc "ORC java command-line tools and utilities"
  homepage "https://orc.apache.org/"
  url "https://search.maven.org/remotecontent?filepath=org/apache/orc/orc-tools/1.5.5/orc-tools-1.5.5-uber.jar"
  sha256 "7cbbb25ffdd7b32c1d83b3cce3d2d41992607597b89ef220f1b2f6d05a0f6f10"

  bottle :unneeded

  def install
    libexec.install "orc-tools-#{version}-uber.jar"
    bin.write_jar_script libexec/"orc-tools-#{version}-uber.jar", "orc-tools"
  end

  test do
    system "#{bin}/orc-tools", "meta", "-h"
  end
end
