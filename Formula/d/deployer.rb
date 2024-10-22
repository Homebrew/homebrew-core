class Deployer < Formula
  desc "Deployment tool written in PHP with support for popular frameworks"
  homepage "https://deployer.org/"
  url "https://github.com/deployphp/deployer/releases/download/v7.5.0/deployer.phar"
  sha256 "6e4df3523f8628b31349121918b31e87f59dc2b33968bb182422241a4f9f56a4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "63e0d349e8eed0a9292d580bbba7dba6208dacf6685b06492c7b0529139e7418"
  end

  depends_on "php"

  def install
    bin.install "deployer.phar" => "dep"
  end

  test do
    system bin/"dep", "init", "--no-interaction"
    assert_predicate testpath/"deploy.php", :exist?
  end
end
