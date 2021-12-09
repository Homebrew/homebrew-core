class Jmxterm < Formula
  desc "Open source, command-line based interactive JMX client"
  homepage "https://docs.cyclopsgroup.org/jmxterm"
  url "https://github.com/jiaqi/jmxterm/releases/download/v1.0.2/jmxterm-1.0.2-uber.jar"
  sha256 "3a8a7cf99d89a3f46fcf3bcfe9bb4838d7778a10730e0983a258edc765fede5c"
  license "Apache-2.0"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "2e3d2fb1fd7afec204e7556a5c7567cab6c7ce3484e91730dcf0b34c1e8729aa"
  end

  depends_on "openjdk@8"

  def install
    libexec.install "jmxterm-#{version}-uber.jar"
    bin.write_jar_script libexec/"jmxterm-#{version}-uber.jar", "jmxterm", "", java_version: "1.8"
  end

  test do
    assert_match(/"software\.name".=."jmxterm";/, pipe_output("#{bin}/jmxterm -n", "about"))
  end
end
