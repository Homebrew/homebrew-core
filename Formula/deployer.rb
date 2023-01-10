class Deployer < Formula
  desc "Deployment tool written in PHP with support for popular frameworks"
  homepage "https://deployer.org/"
  url "https://github.com/deployphp/deployer/releases/download/v7.1.1/deployer.phar"
  sha256 "0a75adcc64df33c4911e505c038579ff1376b77022e4a1581d5e5e23cc0a1ef3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8d9fb3a36317a9b2d5d9bbb1bbba724661faf193dfe744114fb18fbf81e60cd2"
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
