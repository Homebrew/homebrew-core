class Pulumi < Formula
  desc "Define cloud applications and infrastructure in your favorite language"
  homepage "https://pulumi.io/"
  url "https://get.pulumi.com/releases/sdk/pulumi-v0.14.3-darwin-x64.tar.gz"
  version "0.14.3"
  sha256 "57bd3e41f62fc06fdd5742356d659bfd78538153f2cf55cd88faceabc8518b75"

  def install
    ENV["PULUMI_INSTALL_PATH"] = prefix
    system "/bin/sh", "install.sh"
  end

  test do
    output = shell_output("#{bin}/pulumi version")
    assert_match "v0.14.3", output
  end
end
