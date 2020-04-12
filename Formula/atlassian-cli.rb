class AtlassianCli < Formula
  desc "Command-line interface clients for Atlassian products"
  homepage "https://bobswift.atlassian.net/wiki/pages/viewpage.action?pageId=1966101"
  url "https://bobswift.atlassian.net/wiki/download/attachments/16285777/atlassian-cli-9.2.0-distribution.zip"
  sha256 "ba37552b8bd1c637d3444346e4fbc851f35db07dbbbee2919e7f732ab2d482a0"

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
