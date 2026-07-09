class NifiToolkit < Formula
  desc "Command-line utilities to setup and support NiFi"
  homepage "https://nifi.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=nifi/2.10.0/nifi-toolkit-2.10.0-bin.zip"
  mirror "https://archive.apache.org/dist/nifi/2.10.0/nifi-toolkit-2.10.0-bin.zip"
  sha256 "d6012f3ba7612f526a9704fbe796206a844da2adbaa004febc92975ded0dc970"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1ad300d43fe3948bf203ae735fa209d1a0eeeb3f68be7fb735c40e2f8719cc02"
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
