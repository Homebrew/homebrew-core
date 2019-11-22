class Deployer < Formula
  desc "Deployment tool written in PHP with support for popular frameworks"
  homepage "https://deployer.org/"
  url "https://deployer.org/releases/v6.6.0/deployer.phar"
  sha256 "37a5478689477b04c7433d62f97e5727c6a0683c4e08b1959ff0d20c64eab28a"

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
