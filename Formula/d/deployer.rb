class Deployer < Formula
  desc "Deployment tool written in PHP with support for popular frameworks"
  homepage "https://deployer.org/"
  url "https://github.com/deployphp/deployer/releases/download/v7.4.0/deployer.phar"
  sha256 "6321441f8b7377881a0524a4ef5fc8a5f7c414ca1377f5aba9effd15146e6be1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c1fa14ea13cbf8b9956d3aa64b87526123106f947688588a8f3876d9102ecbcc"
  end

  depends_on "php"

  def install
    bin.install "deployer.phar" => "dep"
  end

  test do
    system "#{bin}/dep", "init", "--no-interaction"
    assert_predicate testpath/"deploy.php", :exist?
  end
end
