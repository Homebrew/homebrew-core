class Deployer < Formula
  desc "Deployment tool written in PHP with support for popular frameworks"
  homepage "https://deployer.org/"
  url "https://github.com/deployphp/deployer/releases/download/v7.2.0/deployer.phar"
  sha256 "24ad94880c4b2640217b9bc6bdb18318b4fdb4f1a2b26506fda46dfdcaa6ffb1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e60541a70a8b91e0c5d44ad14434d45952d7b6261ebbc4a374663b302b130926"
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
