class Jmxterm < Formula
  desc "Open source, command-line based interactive JMX client"
  homepage "https://docs.cyclopsgroup.org/jmxterm"
  url "https://github.com/jiaqi/jmxterm/releases/download/v1.0.4/jmxterm-1.0.4-uber.jar"
  sha256 "ce3e78c732a8632f084f8114d50ca5022cef4a69d68a74b45f5007d34349872b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "afe466c4ad8752e59e66da6b83f02c7d772aca26a5f0fcd4d1c5df2a27e92c70"
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
