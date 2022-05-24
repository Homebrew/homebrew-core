class Jmxterm < Formula
  desc "Open source, command-line based interactive JMX client"
  homepage "https://docs.cyclopsgroup.org/jmxterm"
  url "https://github.com/jiaqi/jmxterm/releases/download/v1.0.2/jmxterm-1.0.2-uber.jar"
  sha256 "3a8a7cf99d89a3f46fcf3bcfe9bb4838d7778a10730e0983a258edc765fede5c"
  license "Apache-2.0"
  revision 1

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "be1cdf19cb1f7ca3fe0b5a19b41622e57eda0e4e2343c0468ea7cfb88ce628d3"
  end

  depends_on "openjdk"

  def install
    libexec.install "jmxterm-#{version}-uber.jar"
    bin.write_jar_script libexec/"jmxterm-#{version}-uber.jar", "jmxterm", ""
  end

  test do
    assert_match(/"software\.name".=."jmxterm";/, pipe_output("#{bin}/jmxterm -n", "about"))
  end
end
