class ApibuilderCli < Formula
  desc "Command-line interface to generate clients for api builder"
  homepage "https://www.apibuilder.io"
  url "https://github.com/apicollective/apibuilder-cli/archive/0.1.22.tar.gz"
  sha256 "0a1278cb48ee9610ac2e8bc958ac5f6b46ba7f68d548145443c9ab40782a88c8"

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
