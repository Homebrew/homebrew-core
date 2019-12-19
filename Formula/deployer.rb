class Deployer < Formula
  desc "Deployment tool written in PHP with support for popular frameworks"
  homepage "https://deployer.org/"
  url "https://deployer.org/releases/v6.7.3/deployer.phar"
  sha256 "cd0dc83247d8cc5e65cde437b20f075c12283e80237d7bfd14f8d8d557fbf515"

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
