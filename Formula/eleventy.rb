require "language/node"

class Eleventy < Formula
  desc "Simpler static site generator"
  homepage "https://www.11ty.dev"
  url "https://registry.npmjs.org/@11ty/eleventy/-/eleventy-1.0.2.tgz"
  sha256 "536144e7b38e1b27d44c23c611c4e7ab0442963879f3fa4c1acfe766696728f8"
  license "MIT"
  head "https://github.com/11ty/eleventy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cdccb438e87e4565ebf98a769758f3c1d7785784d660e4465e13f22fe8050975"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cdccb438e87e4565ebf98a769758f3c1d7785784d660e4465e13f22fe8050975"
    sha256 cellar: :any_skip_relocation, monterey:       "d72ac0ce1e37f6c539fee425836dab867e603aba64d9bf2cd13e78823bc7c51f"
    sha256 cellar: :any_skip_relocation, big_sur:        "d72ac0ce1e37f6c539fee425836dab867e603aba64d9bf2cd13e78823bc7c51f"
    sha256 cellar: :any_skip_relocation, catalina:       "d72ac0ce1e37f6c539fee425836dab867e603aba64d9bf2cd13e78823bc7c51f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "159306f1e673b7be583d47f886d308d3ce48d7fd045d90b50f5401919e033456"
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
