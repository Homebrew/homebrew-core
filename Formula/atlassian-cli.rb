class AtlassianCli < Formula
  desc "Command-line interface clients for Atlassian products"
  homepage "https://bobswift.atlassian.net/wiki/pages/viewpage.action?pageId=1966101"
  url "https://bobswift.atlassian.net/wiki/download/attachments/16285777/atlassian-cli-9.1.0-distribution.zip"
  sha256 "60c01f984a75b4e4071eca8f968cdacccf0bde469a9b21fc3abd66206346c2a1"

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
