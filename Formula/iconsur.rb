require "language/node"

class Iconsur < Formula
  desc "macOS Big Sur Adaptive Icon Generator"
  homepage "https://github.com/rikumi/iconsur"
  url "https://registry.npmjs.org/iconsur/-/iconsur-1.6.2.tgz"
  sha256 "86d0f47221ec638c7157e0857f9e4648f9fee89de443b94c252bd7661747bf35"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3d00918b2a9586f778895fe90bfe78350fa532475549ccca7ff1542af2d1e232"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f1f5ce940aedd4c2e3028f770b89027dedf33e5f13a022389afc76eec80c1e2d"
    sha256 cellar: :any_skip_relocation, monterey:       "e69b3cc2b98b39da5122ecc2373aa4c847bf4c3813efc6945b00dc301ce07a9b"
    sha256 cellar: :any_skip_relocation, big_sur:        "a0a04c38eb4980fdfdee8588a981e28f9bc523c4fec0a10cbe8063de5c99bf9a"
    sha256 cellar: :any_skip_relocation, catalina:       "37eb82fad66b4a633e056a178b260b47fbd7e5786e2bd01de435f42ca7ca454d"
    sha256 cellar: :any_skip_relocation, mojave:         "43b9e604727a3cf6c5cf25a10bbadee1ed9b1c31be8bb4bf38a76e09cf547e92"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    mkdir testpath/"Test.app"
    system bin/"iconsur", "set", testpath/"Test.app", "-k", "AppleDeveloper"
    system bin/"iconsur", "cache"
    system bin/"iconsur", "unset", testpath/"Test.app"
  end
end
