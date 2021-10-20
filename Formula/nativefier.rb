require "language/node"

class Nativefier < Formula
  desc "Wrap web apps natively"
  homepage "https://github.com/nativefier/nativefier"
  url "https://registry.npmjs.org/nativefier/-/nativefier-45.0.4.tgz"
  sha256 "7c60f25d0e45bfcd7a33fd0571af6eb741d904a8793789137a218658a1d11113"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c57703c3c97cee01650b15c63096e5f23385cdcf15fd97efaa26f208fdfc48e2"
    sha256 cellar: :any_skip_relocation, big_sur:       "1cc32b34b41e7da11590706b36f317e340f2e6e9725cdeaf588b5228179102dc"
    sha256 cellar: :any_skip_relocation, catalina:      "1cc32b34b41e7da11590706b36f317e340f2e6e9725cdeaf588b5228179102dc"
    sha256 cellar: :any_skip_relocation, mojave:        "1cc32b34b41e7da11590706b36f317e340f2e6e9725cdeaf588b5228179102dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c57703c3c97cee01650b15c63096e5f23385cdcf15fd97efaa26f208fdfc48e2"
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
