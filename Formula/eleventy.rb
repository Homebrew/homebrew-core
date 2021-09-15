require "language/node"

class Eleventy < Formula
  desc "Simpler static site generator"
  homepage "https://www.11ty.dev"
  url "https://registry.npmjs.org/@11ty/eleventy/-/eleventy-0.12.1.tgz"
  sha256 "688cd47c4e23ed67a98392e2639c170bf6b65f896739acb8cbf55b4258bef24d"
  license "MIT"
  head "https://github.com/11ty/eleventy.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1be838b599d0c0dca800c43821d05fdffd641627089025245dc99e301227c096"
    sha256 cellar: :any_skip_relocation, big_sur:       "2b035df0dbb58ace4727c1af9a9de3140e2ba3b9fa5206d934cfd254577a5a0b"
    sha256 cellar: :any_skip_relocation, catalina:      "324dfe311d783ff2a507d1b55ec94bb3152d84ed26041450853032ad427237d7"
    sha256 cellar: :any_skip_relocation, mojave:        "8db3de4db3dd1a611585724b1f9ec38816a2573309caa0fdad88f46f67e3fbbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "041abbc16db2ffcf6aad345b58d80234fa05e388969fff4707ef4dc623f5f9b4"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"README.md").write "# Hello from Homebrew\nThis is a test."
    system bin/"eleventy"
    assert_equal "<h1>Hello from Homebrew</h1>\n<p>This is a test.</p>\n",
                 (testpath/"_site/README/index.html").read
  end
end
