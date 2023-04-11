require "language/node"

class Astgen < Formula
  desc "Generate AST in json format for JS/TS"
  homepage "https://github.com/joernio/astgen"
  url "https://github.com/joernio/astgen/archive/refs/tags/v2.22.0.tar.gz"
  sha256 "2b3e6d712f4214d5c581c568e59b1ca1049622d3de81959b4ed2dc6b5492ea15"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ab5519c94c5e9f4643dfcea04219f474d294b7f9a3ad2b36122c4308b48dcc20"
  end

  depends_on "node"

  def install
    # Disable custom postinstall script
    system "npm", "install", *Language::Node.std_npm_install_args(libexec), "--ignore-scripts"
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"main.js").write <<~EOS
      console.log("Hello, world!");
    EOS

    assert_match "Converted AST", shell_output("#{bin}/astgen -t js -i . -o #{testpath}/out")
    assert_match '"fullName": "main.js"', (testpath/"out/main.js.json").read
    assert_match '"0":"Console"', (testpath/"out/main.js.typemap").read
  end
end
