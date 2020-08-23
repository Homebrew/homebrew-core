require "language/node"

class Alexjs < Formula
  desc "Catch insensitive, inconsiderate writing"
  homepage "https://alexjs.com"
  url "https://github.com/get-alex/alex/archive/8.2.0.tar.gz"
  sha256 "cbcc772d0f26b29d3a39c53d4669d6121b21605b1e9fe923d5976185bdd9558e"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "e8d6589d5b79170372b97a5be30e99c0d11595f0e7730d4e47039684036cc134" => :catalina
    sha256 "241f1cdd33e687cac89401056a63218325f760590f18d6fb49e9560d3de11e41" => :mojave
    sha256 "fe4c67cd281324743c4a3937bd986d879918b563da77ff52dcdec4add60e3849" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.txt").write "garbageman"
    assert_match "garbage collector", shell_output("#{bin}/alex test.txt 2>&1", 1)
  end
end
