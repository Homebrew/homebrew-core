class Astgen < Formula
  desc "Generate AST in json format for JS/TS"
  homepage "https://github.com/joernio/astgen"
  url "https://github.com/joernio/astgen/archive/refs/tags/v3.16.0.tar.gz"
  sha256 "3097f0db0d7dc223c851ed42e2692d2991f36f0e4446321f5f4ef22413af696c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ed39988aab49ef7a4f34118af779465a330dd25bf0a793146552c2c659aed178"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ed39988aab49ef7a4f34118af779465a330dd25bf0a793146552c2c659aed178"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed39988aab49ef7a4f34118af779465a330dd25bf0a793146552c2c659aed178"
    sha256 cellar: :any_skip_relocation, sonoma:         "ed39988aab49ef7a4f34118af779465a330dd25bf0a793146552c2c659aed178"
    sha256 cellar: :any_skip_relocation, ventura:        "ed39988aab49ef7a4f34118af779465a330dd25bf0a793146552c2c659aed178"
    sha256 cellar: :any_skip_relocation, monterey:       "ed39988aab49ef7a4f34118af779465a330dd25bf0a793146552c2c659aed178"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f050211f92e11b55282dcefa185607a3eccd2dc3ea481a3fe84ccab532e46fc4"
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
