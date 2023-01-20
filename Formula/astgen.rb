require "language/node"

class Astgen < Formula
  desc "Generate AST in json format for JS/TS"
  homepage "https://github.com/joernio/astgen"
  url "https://github.com/joernio/astgen/archive/refs/tags/v2.14.0.tar.gz"
  sha256 "aef681ef016dce49f0b6433f078d3451412b1847a4c540362822d0ccf08d5aff"
  license "Apache-2.0"

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec), "--ignore-scripts"
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"main.js").write <<~EOS
      console.log("Hello, world!");
    EOS

    assert_match "Converted AST", shell_output("astgen -t js -i . -o out")
    assert_match '"fullName": "main.js"', File.read("out/main.js.json")
    assert_match '"0":"Console"', File.read("out/main.js.typemap")
  end
end
