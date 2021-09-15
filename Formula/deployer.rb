class Deployer < Formula
  desc "Deployment tool written in PHP with support for popular frameworks"
  homepage "https://deployer.org/"
  url "https://deployer.org/releases/v6.8.0/deployer.phar"
  sha256 "25f639561cb7ebe5c2231b05cb10a0cf62f83469faf6b9248dfa6b7f94e3bd26"

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
