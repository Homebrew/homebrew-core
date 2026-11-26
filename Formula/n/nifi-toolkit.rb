class NifiToolkit < Formula
  desc "Command-line utilities to setup and support NiFi"
  homepage "https://nifi.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=nifi/2.13.0/nifi-toolkit-2.13.0-bin.zip"
  mirror "https://archive.apache.org/dist/nifi/2.13.0/nifi-toolkit-2.13.0-bin.zip"
  sha256 "d6f5d81b09321d8c3fd932efe6b15ac81ec5c564b325a65e335887f37acd016e"
  license "Apache-2.0"

  bottle do
    manifest_sha256 "000cf780c1847db1b7b6e9683f643e5c20d60610a254ce867a14239486ff1562"
    sha256 cellar: :any_skip_relocation, all: "f58269d06d5cce388979d6dca0e30138d458052185d4a9f2aba5397e6525ca23"
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
