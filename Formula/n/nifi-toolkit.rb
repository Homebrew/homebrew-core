class NifiToolkit < Formula
  desc "Command-line utilities to setup and support NiFi"
  homepage "https://nifi.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=nifi/2.12.0/nifi-toolkit-2.12.0-bin.zip"
  mirror "https://archive.apache.org/dist/nifi/2.12.0/nifi-toolkit-2.12.0-bin.zip"
  sha256 "c9bab9d8430c0a780691a45b2bdf197f1c939decb12b808453ceda62942385d8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8c271be227929746efaab9e7adf82c12fbd711d5f5f68ffccae949badf35eec4"
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
