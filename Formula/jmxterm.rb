class Jmxterm < Formula
  desc "Open source, command-line based interactive JMX client"
  homepage "https://wiki.cyclopsgroup.org/jmxterm/"
  url "https://downloads.sourceforge.net/project/cyclops-group/jmxterm/1.0.0/jmxterm-1.0.0-uber.jar"
  sha256 "c1f49b132c435ff5059f48aa560f07feb7a742a9db595ecae7fc34ca0aca054f"

  bottle :unneeded

  depends_on :java => "1.8"

  def install
    libexec.install "jmxterm-#{version}-uber.jar"
    bin.write_jar_script libexec/"jmxterm-#{version}-uber.jar", "jmxterm", "", :java_version => "1.8"
  end

  test do
    assert_match(/\"software\.name\".=.\"jmxterm\";/, shell_output("echo about | #{bin}/jmxterm -n"))
  end
end
