class Deployer < Formula
  desc "Deployment tool written in PHP with support for popular frameworks"
  homepage "https://deployer.org/"
  url "https://github.com/deployphp/deployer/releases/download/v7.5.2/deployer.phar"
  sha256 "b20eca47c9bdc192c4dee88fac6ed72d3823344446441676f17a35ddffaeba3d"
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
