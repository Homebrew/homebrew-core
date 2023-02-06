class Deployer < Formula
  desc "Deployment tool written in PHP with support for popular frameworks"
  homepage "https://deployer.org/"
  url "https://github.com/deployphp/deployer/releases/download/v7.1.4/deployer.phar"
  sha256 "7f85a660cd0a77c4d54c017695e5661cc4e39dae3c43980d45d91646aa72faab"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d7dcfa324aea05cb355d26d690b7afc1fd02317469da2e33e324c0c77a19b45a"
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
