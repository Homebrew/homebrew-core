class Deployer < Formula
  desc "Deployment tool written in PHP with support for popular frameworks"
  homepage "https://deployer.org/"
  url "https://github.com/deployphp/deployer/releases/download/v7.3.3/deployer.phar"
  sha256 "e85f68eeef818d7b09bf50946b006c0a096d23069e26875596e26310a6d06a76"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "df51251ce4e97620c68022dcded42dc43ea33a3a25d963ccb808712cdbaf979c"
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
