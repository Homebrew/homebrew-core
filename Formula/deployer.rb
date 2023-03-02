class Deployer < Formula
  desc "Deployment tool written in PHP with support for popular frameworks"
  homepage "https://deployer.org/"
  url "https://github.com/deployphp/deployer/releases/download/v7.2.1/deployer.phar"
  sha256 "91240458dc4ba1ee8a29e68918b235fc70cba7a3fae24593a062c3d4ca0628f7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f8763fb95f862648eaba3f084f2ef58ae2adb24b7216569a4a846f69bf976cbb"
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
