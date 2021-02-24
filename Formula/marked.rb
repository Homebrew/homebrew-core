require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-2.0.0.tgz"
  sha256 "bb7a41a48214d3791fdf37ce4550708e3ca64342c9d1eb38e24100cf3eaed049"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "074a858c46dd9118767d965c39ea211d2fd44028dc393397419deb7d82208d9a"
    sha256 cellar: :any_skip_relocation, big_sur:       "d842175d91f8eb97238d68bf06f07566d82aa5bb25dde52801fa376f99340d51"
    sha256 cellar: :any_skip_relocation, catalina:      "695e68f395ff8918d236b9d86306449a3a1c9a26ad6c6a82c8d99f7df6ac038c"
    sha256 cellar: :any_skip_relocation, mojave:        "04fff77ad8597aedc8f5fe8c8076889b1982129fea3d3350af3693938abeb94a"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_equal "<p>hello <em>world</em></p>", pipe_output("#{bin}/marked", "hello *world*").strip
  end
end
