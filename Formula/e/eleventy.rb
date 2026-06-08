class Eleventy < Formula
  desc "Simpler static site generator"
  homepage "https://www.11ty.dev"
  url "https://registry.npmjs.org/@11ty/eleventy/-/eleventy-3.1.6.tgz"
  sha256 "326f9e03a76665722c723be64e1021353143f6941fe1f53dd9d700405fd539a3"
  license "MIT"
  head "https://github.com/11ty/eleventy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "94b27b60b4438826b1516f2666aa10d42cbab14a25b3dd69fd4d0fb0928bb7e4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e09d0f667a532e2840324647de55c84bf3d54dab46973a50acf47ab807dc5ef6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e09d0f667a532e2840324647de55c84bf3d54dab46973a50acf47ab807dc5ef6"
    sha256 cellar: :any_skip_relocation, sonoma:        "c6513c134cef2662361aaefd041be5566f06d80b6493117aeb9397b0294c54b1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "61c82722b751635be0dc860c2850b70b43f2ff9cd2a46d80ef7e0adfb009c1fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61c82722b751635be0dc860c2850b70b43f2ff9cd2a46d80ef7e0adfb009c1fb"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    deuniversalize_machos libexec/"lib/node_modules/@11ty/eleventy/node_modules/fsevents/fsevents.node" if OS.mac?
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/"README.md").write "# Hello from Homebrew\nThis is a test."
    system bin/"eleventy"
    assert_equal "<h1>Hello from Homebrew</h1>\n<p>This is a test.</p>\n",
                 (testpath/"_site/README/index.html").read
  end
end
