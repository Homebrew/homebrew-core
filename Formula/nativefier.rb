require "language/node"

class Nativefier < Formula
  desc "Wrap web apps natively"
  homepage "https://github.com/nativefier/nativefier"
  url "https://registry.npmjs.org/nativefier/-/nativefier-45.0.4.tgz"
  sha256 "7c60f25d0e45bfcd7a33fd0571af6eb741d904a8793789137a218658a1d11113"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1588aad46beba55d31237801ed1000d1553dcd94117c3c801e3c2c5ef177749c"
    sha256 cellar: :any_skip_relocation, big_sur:       "4cdad968b0611f181584503b2d5c35052f30e7e4ac9c2118842eecc6acf71a8d"
    sha256 cellar: :any_skip_relocation, catalina:      "4cdad968b0611f181584503b2d5c35052f30e7e4ac9c2118842eecc6acf71a8d"
    sha256 cellar: :any_skip_relocation, mojave:        "4cdad968b0611f181584503b2d5c35052f30e7e4ac9c2118842eecc6acf71a8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1588aad46beba55d31237801ed1000d1553dcd94117c3c801e3c2c5ef177749c"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nativefier --version")
  end
end
