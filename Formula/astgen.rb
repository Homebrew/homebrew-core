require "language/node"

class Astgen < Formula
  desc "Generate AST in json format for JS/TS"
  homepage "https://github.com/joernio/astgen"
  url "https://github.com/joernio/astgen/archive/refs/tags/v2.19.0.tar.gz"
  sha256 "5ac9db9176f9fc3208af0c09f4c6d890c135ee23e173ab624b656a593b857d01"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7989ce86b114aae28c0ee7b1fe2baeb2e384d0c7c00e22bba05186d7de132d74"
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
