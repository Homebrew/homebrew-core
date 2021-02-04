require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-1.2.9.tgz"
  sha256 "b17df81ae36ae3800c0e0eee7da7ede316203b0bc03d649473f5a94c5d4c42be"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a5d888a79d72e2783f56be1f1c280edf4bed83927831c6c4d673974f722d451f"
    sha256 cellar: :any_skip_relocation, big_sur:       "94fc83c11e93166522fb2d56f8a96d3627e622d30f37753106819dce812305d9"
    sha256 cellar: :any_skip_relocation, catalina:      "82f09a4efabd0bfcf70a8b1a4f9cfc8f96cba83eb3088b6708b0bf26975130eb"
    sha256 cellar: :any_skip_relocation, mojave:        "8b68e0bf74c3da4b3b35476ca2577d6d076ee375c02f6eb74c18ede54c9918de"
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
