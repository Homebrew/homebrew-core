class NifiToolkit < Formula
  desc "Command-line utilities to setup and support NiFi"
  homepage "https://nifi.apache.org"
  url "https://dlcdn.apache.org/nifi/2.5.0/nifi-toolkit-2.5.0-bin.zip"
  sha256 "d61e8b1cfc5a42df7b7a8a4ae25d22694cc6cdee381198c81d0a815165ab8343"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "28f8e76c304a613c73e7e42463edffe9fa2101ee8604c6e4cfb6c18e50f5bd75"
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
