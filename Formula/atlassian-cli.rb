class AtlassianCli < Formula
  desc "Command-line interface clients for Atlassian products"
  homepage "https://bobswift.atlassian.net/wiki/pages/viewpage.action?pageId=1966101"
  url "https://bobswift.atlassian.net/wiki/download/attachments/16285777/atlassian-cli-7.1.0-distribution.zip"
  sha256 "d5b1a8c9ad30792e87a1cc562c55ec40dfc9d403f43af66d2b8d9ee78fb39a49"

  bottle :unneeded

  depends_on :java => "1.8+"

  def install
    Dir.glob("*.sh") do |f|
      cmd = File.basename(f, ".sh")
      inreplace cmd + ".sh", "`dirname $0`", share
      bin.install cmd + ".sh" => cmd
    end
    share.install "lib", "license"
  end

  test do
    Dir.glob(bin/"*") do |f|
      cmd = File.basename(f, ".sh")
      assert_match "Usage:", shell_output(bin/"#{cmd} --help 2>&1 | head") unless cmd == "atlassian"
    end
  end
end
