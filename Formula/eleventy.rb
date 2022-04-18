require "language/node"

class Eleventy < Formula
  desc "Simpler static site generator"
  homepage "https://www.11ty.dev"
  url "https://registry.npmjs.org/@11ty/eleventy/-/eleventy-1.0.1.tgz"
  sha256 "2740d2c85b97f10ea3ce04fd41f860072186fb3dd2d67f5de54f0236cf0614c2"
  license "MIT"
  head "https://github.com/11ty/eleventy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d910e459aa16ce26c593d1fd46655f746c9450abdd0e76c958e0c8a41ed29648"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d910e459aa16ce26c593d1fd46655f746c9450abdd0e76c958e0c8a41ed29648"
    sha256 cellar: :any_skip_relocation, monterey:       "eff8f3ac66694f2989ce1d5c39b3068145d294c11b1736592fad9d4f95e675da"
    sha256 cellar: :any_skip_relocation, big_sur:        "eff8f3ac66694f2989ce1d5c39b3068145d294c11b1736592fad9d4f95e675da"
    sha256 cellar: :any_skip_relocation, catalina:       "3195839078c4a82f005fa171efb8dd6ea53830b05096e8776d2b583fb8c33bfc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b239ff3de617a604fadf891ed1229065015e3096143c4b13d5b3f8596c0d7a4d"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
    deuniversalize_machos
  end

  test do
    (testpath/"README.md").write "# Hello from Homebrew\nThis is a test."
    system bin/"eleventy"
    assert_equal "<h1>Hello from Homebrew</h1>\n<p>This is a test.</p>\n",
                 (testpath/"_site/README/index.html").read
  end
end
