class Deployer < Formula
  desc "Deployment tool written in PHP with support for popular frameworks"
  homepage "https://deployer.org/"
  url "https://github.com/deployphp/deployer/releases/download/v7.3.1/deployer.phar"
  sha256 "5ffe5db394fee893ab562382a11a3c14604e90272825c41348d3928da5f1ae9d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9d3a0df77b981e45f88dbd2feccf62a4a19178818dcd160c652a2cffec282d64"
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
