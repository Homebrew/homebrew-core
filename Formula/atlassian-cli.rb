class AtlassianCli < Formula
  desc "Command-line interface clients for Atlassian products"
  homepage "https://bobswift.atlassian.net/wiki/pages/viewpage.action?pageId=1966101"
  url "https://bobswift.atlassian.net/wiki/download/attachments/16285777/atlassian-cli-9.5.0-distribution.zip"
  sha256 "3fee080b7d1042d24721227a0a7182ad6e6c00833d9e66ac14c77b0f39920f05"

  livecheck do
    url "https://marketplace.atlassian.com/apps/10886/atlassian-command-line-interface-cli/version-history"
    regex(/class="version">v?(\d+(?:\.\d+)+)</i)
  end

  bottle :unneeded

  depends_on "openjdk"

  def install
    inreplace "acli.sh" do |s|
      s.sub! "`find \"$directory/lib\" -name acli-*.jar`", "'#{share}/lib/acli-#{version}.jar'"
      s.sub! "java", "'#{Formula["openjdk"].opt_bin}/java'"
    end
    bin.install "acli.sh" => "acli"
    share.install "lib", "license"
  end

  test do
    assert_match "Welcome to the Bob Swift Atlassian CLI", shell_output("#{bin}/acli --help 2>&1 | head")
  end
end
