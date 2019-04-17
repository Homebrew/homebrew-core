class Deployer < Formula
  desc "Deployment tool written in PHP with support for popular frameworks"
  homepage "https://deployer.org/"
  url "https://deployer.org/releases/v6.4.3/deployer.phar"
  sha256 "d0b0d4dbd834c1d5e387981042d452017dd92eb5db00c8fa1db31ad343d9bedf"

  bottle :unneeded

  depends_on "php"

  conflicts_with "dep", :because => "both install `dep` binaries"

  def install
    bin.install "deployer.phar" => "dep"
  end

  test do
    system "#{bin}/dep", "init", "--template=Common"
    assert_predicate testpath/"deploy.php", :exist?
  end
end
