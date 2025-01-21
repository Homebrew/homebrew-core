class Deployer < Formula
  desc "Deployment tool written in PHP with support for popular frameworks"
  homepage "https://deployer.org/"
  url "https://github.com/deployphp/deployer/releases/download/v7.5.8/deployer.phar"
  sha256 "72bc7b3508a7877b7b4fe3877de72738ff28b512a056ccfbcc432d0baf325ec6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a9b3fbfa0f721119a455a73ae0e0ae7c598f789eba0e7ebfe093c49f79638abb"
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
