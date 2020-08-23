class Jmxterm < Formula
  desc "Open source, command-line based interactive JMX client"
  homepage "https://docs.cyclopsgroup.org/jmxterm"
  url "https://github.com/jiaqi/jmxterm/releases/download/v1.0.1/jmxterm-1.0.1-uber.jar"
  sha256 "76e0dae56b410c77724b561897e9073f088bd0b6158d668147d466debac6e9b0"
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
