class Deployer < Formula
  desc "Deployment tool written in PHP with support for popular frameworks"
  homepage "https://deployer.org/"
  url "https://deployer.org/releases/v6.4.6/deployer.phar"
  sha256 "7ed6cfb6ade4e326b712e534ba8d578a4df4bc40006086dc596d48494d9c6260"

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
