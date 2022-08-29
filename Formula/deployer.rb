class Deployer < Formula
  desc "Deployment tool written in PHP with support for popular frameworks"
  homepage "https://deployer.org/"
  url "https://github.com/deployphp/deployer/releases/download/v7.0.1/deployer.phar"
  sha256 "63119af2c18d5be19f91a8fb9665ac00217190d5e08cc0ad83510a558dd53794"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ed7260dc5eb44314da6c26f8011961042f01b8731af4fae1a533d85ef5b0f4e4"
  end

  depends_on "php"

  conflicts_with "dep", because: "both install `dep` binaries"

  def install
    bin.install "deployer.phar" => "dep"
  end

  test do
    system "#{bin}/dep", "init", "--no-interaction"
    assert_predicate testpath/"deploy.php", :exist?
  end
end
