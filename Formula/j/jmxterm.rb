class Jmxterm < Formula
  desc "Open source, command-line based interactive JMX client"
  homepage "https://docs.cyclopsgroup.org/jmxterm"
  url "https://github.com/jiaqi/jmxterm/releases/download/v1.0.4/jmxterm-1.0.4-uber.jar"
  sha256 "ce3e78c732a8632f084f8114d50ca5022cef4a69d68a74b45f5007d34349872b"
  license "Apache-2.0"

  bottle do
    rebuild 1
    manifest_sha256 "d187d4f2906a5be9e4dac763ed016db0c2f051a415277f2f0ff522d881b9d81d"
    sha256 cellar: :any_skip_relocation, all: "03113ff040a52832b1202c64ba4b784662b455e6aea16641d42206fa7c770661"
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
