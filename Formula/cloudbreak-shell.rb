class CloudbreakShell < Formula
  desc "CLI shell for the Cloudbreak project"
  homepage "https://github.com/sequenceiq/cloudbreak/tree/master/shell"
  url "https://s3-eu-west-1.amazonaws.com/maven.sequenceiq.com/releases/com/sequenceiq/cloudbreak-shell/1.4.0-rc.15/cloudbreak-shell-1.4.0-rc.15.jar"
  version "1.4.0-rc.15"
  sha256 "79b00c1744f26346f5a01417e984ce87582b64e741377589d4cf2f66e5f3d548"

  bottle :unneeded

  depends_on :java => "1.8+"

  def install
    libexec.install "cloudbreak-shell-#{version}.jar" => "cloudbreak-shell.jar"
    bin.write_jar_script libexec/"cloudbreak-shell.jar", "cloudbreak-shell"
  end

  test do
    output = shell_output("#{bin}/cloudbreak-shell")
    assert_match /Cloudbreak Shell:/, output
    assert_match /Usage:/, output
  end
end
