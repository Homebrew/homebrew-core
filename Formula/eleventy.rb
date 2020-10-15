require "language/node"

class Eleventy < Formula
  desc "Simpler static site generator"
  homepage "https://www.11ty.dev"
  url "https://registry.npmjs.org/@11ty/eleventy/-/eleventy-0.11.0.tgz"
  sha256 "1430be9f422802b1833b116822b9526ee58e59b627d67842df5cf2d8ef84f65e"
  license "MIT"
  head "https://github.com/11ty/eleventy.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "46d20c5bec31be5785cd494a3925e2b3f8231800d865e98e025bf637e131ea86" => :catalina
    sha256 "eddd72fbb882382129956d2ef4b27671ede98db7681a6134096371a248dbec1c" => :mojave
    sha256 "69ab30317e492a8e467cc77f91a7c1ca961269071939bb5c4b56ab9e8ea4c595" => :high_sierra
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
