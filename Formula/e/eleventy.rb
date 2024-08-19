class Eleventy < Formula
  desc "Simpler static site generator"
  homepage "https://www.11ty.dev"
  url "https://registry.npmjs.org/@11ty/eleventy/-/eleventy-2.0.1.tgz"
  sha256 "08236b693a3a1076b32f6bcba45ae132fbadf1fc2c52eae0cc33951bcd2163dd"
  license "MIT"
  head "https://github.com/11ty/eleventy.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ecfe465a1b07add1f0c6bdf3fb6accef3abcbf2fd81db6eae155da26a235a477"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ecfe465a1b07add1f0c6bdf3fb6accef3abcbf2fd81db6eae155da26a235a477"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ecfe465a1b07add1f0c6bdf3fb6accef3abcbf2fd81db6eae155da26a235a477"
    sha256 cellar: :any_skip_relocation, sonoma:         "bac187fe950966d6957443d4248b67f596ef7a1e5484d752d7801c4fbe7b07e5"
    sha256 cellar: :any_skip_relocation, ventura:        "bac187fe950966d6957443d4248b67f596ef7a1e5484d752d7801c4fbe7b07e5"
    sha256 cellar: :any_skip_relocation, monterey:       "bac187fe950966d6957443d4248b67f596ef7a1e5484d752d7801c4fbe7b07e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6c5486cb85e23084f7fb25e156b8859803caffcf1ec844d9dd19e8d69faf697"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
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
