require "language/node"

class Prettier < Formula
  desc "Code formatter for JavaScript, CSS, JSON, GraphQL, Markdown, YAML"
  homepage "https://prettier.io/"
  url "https://registry.npmjs.org/prettier/-/prettier-2.4.1.tgz"
  sha256 "3c19d08daa9f78170493a4022a1901c51bf67b405c0b72c14ad607a28cb243e6"
  license "MIT"
  head "https://github.com/prettier/prettier.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ff333e5a85072c16ffc3e45c547ee03adbd2db1ccfcad6530e676cdde8829f9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8ff333e5a85072c16ffc3e45c547ee03adbd2db1ccfcad6530e676cdde8829f9"
    sha256 cellar: :any_skip_relocation, monterey:       "bf7b106b0628675290c36da366cc9c4caf1d1883f66634410520f2fefd58ac82"
    sha256 cellar: :any_skip_relocation, big_sur:        "bf7b106b0628675290c36da366cc9c4caf1d1883f66634410520f2fefd58ac82"
    sha256 cellar: :any_skip_relocation, catalina:       "bf7b106b0628675290c36da366cc9c4caf1d1883f66634410520f2fefd58ac82"
    sha256 cellar: :any_skip_relocation, mojave:         "bf7b106b0628675290c36da366cc9c4caf1d1883f66634410520f2fefd58ac82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ff333e5a85072c16ffc3e45c547ee03adbd2db1ccfcad6530e676cdde8829f9"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.js").write("const arr = [1,2];")
    output = shell_output("#{bin}/prettier test.js")
    assert_equal "const arr = [1, 2];", output.chomp
  end
end
