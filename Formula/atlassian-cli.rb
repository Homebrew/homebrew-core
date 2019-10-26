class AtlassianCli < Formula
  desc "Command-line interface clients for Atlassian products"
  homepage "https://bobswift.atlassian.net/wiki/pages/viewpage.action?pageId=1966101"
  url "https://bobswift.atlassian.net/wiki/download/attachments/16285777/atlassian-cli-9.0.0-distribution.zip"
  sha256 "3bf1760d6d2dae8fad7cfba9666de61ac0f58883c5c2c2744a4a90356670f1a7"

  bottle :unneeded

  depends_on :java => "1.8+"

  def install
    Dir.glob("*.sh") do |f|
      cmd = File.basename(f, ".sh")
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
