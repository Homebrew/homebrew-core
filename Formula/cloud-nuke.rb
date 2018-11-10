class CloudNuke < Formula
  desc "Cleaning up your cloud accounts by nuking all resources in it"
  homepage "https://gruntwork.io/"
  url "https://github.com/gruntwork-io/cloud-nuke/releases/download/v0.1.4/cloud-nuke_darwin_amd64"
  version "0.1.4"
  sha256 "eaf6cdc9d7590f1db4c3c266dd8ba29e04877082cfd06d372602045aafeee5a6"

  def install
    bin.install "cloud-nuke_darwin_amd64"
    mv bin/"cloud-nuke_darwin_amd64", bin/"cloud-nuke"
  end

  test do
    assert_match "cloud-nuke version v0.1.4", shell_output("#{bin}/cloud-nuke -v ")
  end
end
