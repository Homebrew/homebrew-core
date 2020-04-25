class Deployer < Formula
  desc "Deployment tool written in PHP with support for popular frameworks"
  homepage "https://deployer.org/"
  url "https://deployer.org/releases/v6.8.0/deployer.phar"
  sha256 "25f639561cb7ebe5c2231b05cb10a0cf62f83469faf6b9248dfa6b7f94e3bd26"

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
