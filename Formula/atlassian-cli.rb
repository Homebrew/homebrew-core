class AtlassianCli < Formula
  desc "Command-line interface clients for Atlassian products"
  homepage "https://bobswift.atlassian.net/wiki/pages/viewpage.action?pageId=1966101"
  url "https://bobswift.atlassian.net/wiki/download/attachments/16285777/atlassian-cli-9.1.1-distribution.zip"
  sha256 "9f972422b3ad425054c76a1ac89434a38fe70fa398414c5136981c7c54bcd8b8"
  revision 1

  bottle :unneeded

  depends_on "openjdk"

  def install
    inreplace "acli.sh" do |s|
      s.sub! "`find $directory -name acli-*.jar`", "'#{share}/lib/acli-#{version}.jar'"
      s.sub! "java", "'#{Formula["openjdk"].opt_bin}/java'"
    end
    bin.install "acli.sh" => "acli"
    share.install "lib", "license"
  end

  test do
    assert_match "Welcome to the Atlassian CLI", shell_output("#{bin}/acli --help 2>&1 | head")
  end
end
