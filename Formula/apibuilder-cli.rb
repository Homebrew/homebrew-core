class ApibuilderCli < Formula
  desc "Command-line interface to generate clients for api builder"
  homepage "https://www.apibuilder.io"
  url "https://github.com/apicollective/apibuilder-cli/archive/0.1.13.tar.gz"
  sha256 "dbabb2782f339482b0cbfa27c41015f42e8aa39081cf66ca6677243e3cf27939"

  bottle :unneeded

  def install
    system "./install.sh", prefix
  end

  test do
    (testpath/"config").write <<~EOS
      [default]
      token = abcd1234
    EOS
    assert_match "Profile default:",
                 shell_output("#{bin}/read-config --path config")
    assert_match "Could not find apibuilder configuration directory",
                 shell_output("#{bin}/apibuilder", 1)
  end
end
