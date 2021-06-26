require "language/node"

class Nativefier < Formula
  desc "Wrap web apps natively"
  homepage "https://github.com/nativefier/nativefier"
  url "https://registry.npmjs.org/nativefier/-/nativefier-44.0.5.tgz"
  sha256 "8600e31226b89a65d63beb844859de8a78524bf20be93d88b19858b848e0a2d4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f90d331648e43c656ddbd882fd3f9f70f78984dd364144f7693fd3a09673efda"
    sha256 cellar: :any_skip_relocation, big_sur:       "cda057e052ea53f7e66f871942ec1061eb122f1470bf25596cbadfca57d1700d"
    sha256 cellar: :any_skip_relocation, catalina:      "cda057e052ea53f7e66f871942ec1061eb122f1470bf25596cbadfca57d1700d"
    sha256 cellar: :any_skip_relocation, mojave:        "cda057e052ea53f7e66f871942ec1061eb122f1470bf25596cbadfca57d1700d"
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
