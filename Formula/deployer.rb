class Deployer < Formula
  desc "Deployment tool written in PHP with support for popular frameworks"
  homepage "https://deployer.org/"
  url "https://github.com/deployphp/deployer/releases/download/v7.0.0/deployer.phar"
  sha256 "34a234b6acccd1b6f214df570ff118a9fcea91dc06be53f75d0fc702cc38ace5"

  # The first-party download page now uses client-side rendering, so we have to
  # check a JSON file used on the page that contains the version information.
  livecheck do
    url "https://deployer.org/manifest.json"
    regex(%r{\\?/releases\\?/v?(\d+(?:\.\d+)+)\\?/deployer\.phar}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c8f15a518a11552ea9bdf2ff350918e20b14b4e31b1fab1c2471b24c6ee743f4"
  end

  depends_on "php"

  conflicts_with "dep", because: "both install `dep` binaries"

  def install
    bin.install "deployer.phar" => "dep"
  end

  test do
    system "#{bin}/dep", "init", "--template=Common"
    assert_predicate testpath/"deploy.php", :exist?
  end
end
