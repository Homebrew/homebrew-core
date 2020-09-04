class Jmxterm < Formula
  desc "Open source, command-line based interactive JMX client"
  homepage "https://docs.cyclopsgroup.org/jmxterm"
  url "https://github.com/jiaqi/jmxterm/releases/download/v1.0.2/jmxterm-1.0.2-uber.jar"
  sha256 "3a8a7cf99d89a3f46fcf3bcfe9bb4838d7778a10730e0983a258edc765fede5c"
  license "Apache-2.0"

  bottle :unneeded

  depends_on java: "1.8"

  def install
    libexec.install "jmxterm-#{version}-uber.jar"
    bin.write_jar_script libexec/"jmxterm-#{version}-uber.jar", "jmxterm", "", java_version: "1.8"
  end

  test do
    assert_match(/"software\.name".=."jmxterm";/, shell_output("echo about | #{bin}/jmxterm -n"))
  end
end
