class Astgen < Formula
  desc "Generate AST in json format for JS/TS"
  homepage "https://github.com/joernio/astgen"
  url "https://github.com/joernio/astgen/archive/refs/tags/v3.18.0.tar.gz"
  sha256 "fd675ca31cf16da22be3a7f8ab393b3c01862773d00797262b1d79c41c330924"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8a3ff787bb98219536e744663035f15f53b7ee2db59ffee934b0a422fc73476a"
  end

  depends_on "node"

  uses_from_macos "zlib"

  def install
    # Disable custom postinstall script
    system "npm", "install", *std_npm_args, "--ignore-scripts"
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"main.js").write <<~EOS
      console.log("Hello, world!");
    EOS

    assert_match "Converted AST", shell_output("#{bin}/astgen -t js -i . -o #{testpath}/out")
    assert_match '"fullName": "main.js"', (testpath/"out/main.js.json").read
    assert_match '"0": "Console"', (testpath/"out/main.js.typemap").read
  end
end
