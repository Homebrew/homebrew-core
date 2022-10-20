require "language/node"

class Eleventy < Formula
  desc "Simpler static site generator"
  homepage "https://www.11ty.dev"
  url "https://registry.npmjs.org/@11ty/eleventy/-/eleventy-1.0.2.tgz"
  sha256 "536144e7b38e1b27d44c23c611c4e7ab0442963879f3fa4c1acfe766696728f8"
  license "MIT"
  head "https://github.com/11ty/eleventy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3964b8a92c0fe9b3c731c4588c6d553775d1c83cb67a943b0aa2819d61ea2509"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3964b8a92c0fe9b3c731c4588c6d553775d1c83cb67a943b0aa2819d61ea2509"
    sha256 cellar: :any_skip_relocation, monterey:       "37efa77486af2fd8c2f60998b446545b35d5e4f7f60e13e657fccc9a195e5b5c"
    sha256 cellar: :any_skip_relocation, big_sur:        "37efa77486af2fd8c2f60998b446545b35d5e4f7f60e13e657fccc9a195e5b5c"
    sha256 cellar: :any_skip_relocation, catalina:       "37efa77486af2fd8c2f60998b446545b35d5e4f7f60e13e657fccc9a195e5b5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5a251c2696134b0376e1f3e3d15c061184b8f801b19c196171a2c4afdfe7a21"
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
