class Deployer < Formula
  desc "Deployment tool written in PHP with support for popular frameworks"
  homepage "https://deployer.org/"
  url "https://github.com/deployphp/deployer/releases/download/v8.0.0/deployer.phar"
  sha256 "1e66bb61aae2f3e727b88ec8bd1e05b260967dea35630d50e1f96b386c51b342"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "902b0df3a49ce508e270207ab70b8b360099342027f43e968a48bd6466f1c1a1"
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
