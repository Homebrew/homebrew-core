class Deployer < Formula
  desc "Deployment tool written in PHP with support for popular frameworks"
  homepage "https://deployer.org/"
  url "https://github.com/deployphp/deployer/releases/download/v8.0.5/deployer.phar"
  sha256 "0026dfa73626a8ccde06222fe5fccf03e6d4a19e765914bb87d7d2cc21f3e57d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "30faf6172ee6025effbbebc49d712af4fad206520d4337e7f8bbaa534c5c7fbc"
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
