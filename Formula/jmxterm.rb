class Jmxterm < Formula
  desc "Open source, command-line based interactive JMX client"
  homepage "https://docs.cyclopsgroup.org/jmxterm"
  url "https://github.com/jiaqi/jmxterm/releases/download/v1.0.3/jmxterm-1.0.3-uber.jar"
  sha256 "04b16c9e49b77acbe33014fbf564dc07fac4f223b63ef8bfa865abfed337155f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "29b956c7183066e8c41f5e72ecf54d801781b007a391bc0f64bbb33f89a69e2d"
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
