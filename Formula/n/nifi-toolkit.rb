class NifiToolkit < Formula
  desc "Command-line utilities to setup and support NiFi"
  homepage "https://nifi.apache.org"
  url "https://dlcdn.apache.org/nifi/2.8.0/nifi-toolkit-2.8.0-bin.zip"
  sha256 "d025e9f6ff2f102f961967780ccf4cb3593365b9b51d2df17653ebc2e61a7d67"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "61f21b8b62b80205337fa0b985f210b1e64746818aaa3fd744471eda0bfbeaf3"
  end

  depends_on "openjdk@21"

  def install
    libexec.install Dir["*"]

    (bin/"nifi-cli").write_env_script(
      libexec/"bin/cli.sh",
      Language::Java.overridable_java_home_env("21").merge(NIFI_TOOLKIT_HOME: libexec),
    )
  end

  test do
    assert_match "commands:", shell_output("#{bin}/nifi-cli help")
    assert_match "Missing required option 'baseUrl'", shell_output("#{bin}/nifi-cli nifi get-node 2>&1", 255)
    session_keys = shell_output("#{bin}/nifi-cli session keys")
    assert_match "nifi.props", session_keys
    assert_match "nifi.reg.props", session_keys
  end
end
