class Deployer < Formula
  desc "Deployment tool written in PHP with support for popular frameworks"
  homepage "https://deployer.org/"
  url "https://github.com/deployphp/deployer/releases/download/v7.0.2/deployer.phar"
  sha256 "0dd3d3a4aac4b27338359843fc9f4f974b06276c2854b41b6fd54b0786473936"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7fc6d1d75cd13d0af6b27cd9d944f6860c6c98970e76b5636ecf84f1e08e3d71"
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
