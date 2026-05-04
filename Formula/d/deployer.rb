class Deployer < Formula
  desc "Deployment tool written in PHP with support for popular frameworks"
  homepage "https://deployer.org/"
  url "https://github.com/deployphp/deployer/releases/download/v8.0.2/deployer.phar"
  sha256 "665f9fbbeaa9af58ebd87dfc6f66ef6436db99324baf486f1d28d27fcfcfadd0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4303c8db65dfab9825583d2179bf725d6128a385dfda97277645125d9fa1f7ad"
  end

  depends_on "php"

  def install
    bin.install "deployer.phar" => "dep"
  end

  test do
    system bin/"dep", "init", "--no-interaction"
    assert_path_exists testpath/"deploy.php"
  end
end
