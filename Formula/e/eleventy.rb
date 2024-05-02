require "language/node"

class Eleventy < Formula
  desc "Simpler static site generator"
  homepage "https://www.11ty.dev"
  url "https://registry.npmjs.org/@11ty/eleventy/-/eleventy-2.0.1.tgz"
  sha256 "08236b693a3a1076b32f6bcba45ae132fbadf1fc2c52eae0cc33951bcd2163dd"
  license "MIT"
  head "https://github.com/11ty/eleventy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6fa8b9bd74c83ffa168943adb11ad6cd465313d6cafeb9e40dd4980c5a4741f3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "07bbbe3636a0dad5d9918d590e0b04aec34f2e020f5219fed0e42e088b047edb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "07bbbe3636a0dad5d9918d590e0b04aec34f2e020f5219fed0e42e088b047edb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "07bbbe3636a0dad5d9918d590e0b04aec34f2e020f5219fed0e42e088b047edb"
    sha256 cellar: :any_skip_relocation, sonoma:         "f92dfbb2e8ac70a4779ca9b7136a3d7924a8e86dad6a4861c0589893df3e8ec5"
    sha256 cellar: :any_skip_relocation, ventura:        "f5759125de05b3f6e0d60d91812df638a14d441be0cd852da1ce2837200dfcf2"
    sha256 cellar: :any_skip_relocation, monterey:       "f5759125de05b3f6e0d60d91812df638a14d441be0cd852da1ce2837200dfcf2"
    sha256 cellar: :any_skip_relocation, big_sur:        "f5759125de05b3f6e0d60d91812df638a14d441be0cd852da1ce2837200dfcf2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0c6b71e62f97215150817b5513e3c30c1670a575645e91eb0cfc94b68f87ac37"
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
