require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-3.0.3.tgz"
  sha256 "f9f0cd04d5732fe58108b74be49e316ae419181aa383c2871b66402fd0ec5de3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e73b3c547be314e68dd1ad38fbe3156ef8ec8c55abec05462f6aea6d0728c093"
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
