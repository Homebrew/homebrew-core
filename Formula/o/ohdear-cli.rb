class OhdearCli < Formula
  desc "Tool to manage your Oh Dear sites"
  homepage "https://ohdear.app"
  url "https://github.com/ohdearapp/ohdear-cli/releases/download/v5.5.0/ohdear.phar"
  sha256 "8e25da54190663a9cbe298e410d71755f36fae8977c17a65a532348da148e0f8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "08c5e9d7f0693bb17ac54631509b1ca214b30f6efadb208814acfc116e7dc4a0"
  end

  depends_on "php"

  allow_network_access! :test

  def install
    bin.install "ohdear.phar" => "ohdear"
    # The cli tool was renamed (3.x -> 4.0.0)
    # Create a symlink to not break compatibility
    bin.install_symlink bin/"ohdear" => "ohdear-cli"
  end

  test do
    assert_match "Your API token is invalid or expired.", shell_output("#{bin}/ohdear get-me", 1)
  end
end
