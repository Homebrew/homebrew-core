require "language/node"

class Eleventy < Formula
  desc "Simpler static site generator"
  homepage "https://www.11ty.dev"
  url "https://registry.npmjs.org/@11ty/eleventy/-/eleventy-2.0.0.tgz"
  sha256 "c0aba966ec5e78f4253d3c204b9e934761386e309d55cc20e867424707a8e58a"
  license "MIT"
  head "https://github.com/11ty/eleventy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6b336c6ff552e3363e0e3babf5ad2a819a5a2c94ab94fc6f04b6a3e2d85c6813"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68dc4640f8a935014c211139757a249165b272f8b46ea8d7ddf1eda7d426568b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "118808cfed8501bbcba58b851a006eff1dc7d9efb65a530b3cc8e02e7ecec77b"
    sha256 cellar: :any_skip_relocation, ventura:        "0796f8eef59758495900116ce13ee122fc18f44aeee2dfacc5d81abd3c76be47"
    sha256 cellar: :any_skip_relocation, monterey:       "9fb418ea8c4cc7d0f7fc216f176a436e82fd1d0c11eac3fc427efaeb1e910d22"
    sha256 cellar: :any_skip_relocation, big_sur:        "060ea1a8fc6e66e9a3dfdf8cd7b0be583da085fbb6c6e1d0165e338f710ecfe1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b15f028e0c18b4a49f4b9c36ac8d492538a71935fa43a91d7f51108f76283d5"
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
