class Deployer < Formula
  desc "Deployment tool written in PHP with support for popular frameworks"
  homepage "https://deployer.org/"
  url "https://github.com/deployphp/deployer/releases/download/v7.5.11/deployer.phar"
  sha256 "864b980e25727f2794a711a04dda29314ffc031bc7767846d60c79e5e0adc574"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c2936d207c8a49609aeb7b63861cd103c9d05929562e6807c8452072f589ad2d"
  end

  depends_on "php"

  def install
    bin.install "deployer.phar" => "dep"
  end

  test do
    system bin/"dep", "init", "--no-interaction"
    assert_path_exists testpath/"deploy.php"
  end
end
