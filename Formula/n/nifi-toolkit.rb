class NifiToolkit < Formula
  desc "Command-line utilities to setup and support NiFi"
  homepage "https://nifi.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=nifi/2.9.0/nifi-toolkit-2.9.0-bin.zip"
  mirror "https://archive.apache.org/dist/nifi/2.9.0/nifi-toolkit-2.9.0-bin.zip"
  sha256 "67b729e91b28028c1582a6e896d9e4e3d7bf33fa6c49f3abd19d23b41b1350b8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "eff9d1d6831ac428d094794abcc96f538e9a2a6872b118f305821d7343c6c7b5"
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
