class CloudbreakShell < Formula
  desc "CLI shell for the Cloudbreak project"
  homepage "https://github.com/sequenceiq/cloudbreak/tree/master/shell"
  url "https://s3-eu-west-1.amazonaws.com/maven.sequenceiq.com/releases/com/sequenceiq/cloudbreak-shell/1.4.0-rc.15/cloudbreak-shell-1.4.0-rc.15.jar"
  version "1.4.0-rc.15"
  sha256 "79b00c1744f26346f5a01417e984ce87582b64e741377589d4cf2f66e5f3d548"

  bottle :unneeded

  depends_on :java => "1.8+"

  def bin_wrapper; <<-EOS.undent
    #!/bin/sh
    exec java -jar #{libexec}/cloudbreak-shell.jar "$@"
    EOS
  end

  def install
    libexec.install "cloudbreak-shell-#{version}.jar" => "cloudbreak-shell.jar"
    (bin/"cloudbreak-shell").write(bin_wrapper)
  end

  def caveats; <<-EOS.undent
    CloudBreak Shell requires the Java Runtime Engine (JRE) version 8.x or
    newer; it will not run on older JRE versions.
    EOS
  end

  test do
    File.exist? "#{bin}/cloudbreak-shell"
    File.exist? "#{libexec}/cloudbreak-shell.jar"
  end
end
