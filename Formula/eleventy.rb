require "language/node"

class Eleventy < Formula
  desc "Simpler static site generator"
  homepage "https://www.11ty.dev"
  url "https://registry.npmjs.org/@11ty/eleventy/-/eleventy-0.11.1.tgz"
  sha256 "55dfb1dedffff5598a1f9900250530ad8b1d7b91eb5ef0760ef8e27104f7ed5f"
  license "MIT"
  head "https://github.com/11ty/eleventy.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "64da97482a293690e92c421891298f82c6c97a3fa3a96ef2c0b40b1a320d5593" => :big_sur
    sha256 "ab1fb1cab906237826c8153078356bb4341c9771aaaf8e38d51f6974be32c944" => :arm64_big_sur
    sha256 "48934e50a9eee9eb34e6011eeb829c9995c102a5bd7d1c02eb041d0ba119ee52" => :catalina
    sha256 "0d259029be276276315bfa3cef874a0af1cbe4553ad5a6d5e09794ad70a7a6fb" => :mojave
    sha256 "bd861131b89565c4637c60f11d7e2dfdb76220517005ab22bb8ef4f52720ed5c" => :high_sierra
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
