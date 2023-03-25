class Deployer < Formula
  desc "Deployment tool written in PHP with support for popular frameworks"
  homepage "https://deployer.org/"
  url "https://github.com/deployphp/deployer/releases/download/v7.3.0/deployer.phar"
  sha256 "49346eaec55368eed16dce93d38a9cf8fb8eccc0860a6ef6528cb266c5dc27aa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a063f21da037c5550709198904385c14e9c5beadfdc0f5c988fa76fb75bb9ecf"
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
