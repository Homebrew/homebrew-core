require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-13.0.0.tgz"
  sha256 "4f745b70c992a1511efadf24f9b363fe4493d326c57faf657276104f4e24cc47"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3fa4be245a5330c28d986fcb198c35e25e122991882bdbe8601ad76f165dbf33"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3fa4be245a5330c28d986fcb198c35e25e122991882bdbe8601ad76f165dbf33"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3fa4be245a5330c28d986fcb198c35e25e122991882bdbe8601ad76f165dbf33"
    sha256 cellar: :any_skip_relocation, sonoma:         "ae4b3bd58d952e0f700219ac5a67b1112c5472832542300810b6b3452bf02531"
    sha256 cellar: :any_skip_relocation, ventura:        "ae4b3bd58d952e0f700219ac5a67b1112c5472832542300810b6b3452bf02531"
    sha256 cellar: :any_skip_relocation, monterey:       "3fa4be245a5330c28d986fcb198c35e25e122991882bdbe8601ad76f165dbf33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a00da522de59a1b2e5a124ef33c7e31e9ea046ecd279408ddc4650f502f3509c"
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
