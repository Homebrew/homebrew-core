require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-7.11.0.tgz"
  sha256 "f4d34cfb473c42d49406dfbe314bea1b920a7537360765e5da5cf64dd822ae7f"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "37cdc4e0d0a9a0e62e1f0573c3fa429f40d8b9fe1e17d33751974e37bd7f191e" => :catalina
    sha256 "f4f00dc48a3e2846f5e136a1d44c0fe0ad2d8684cc6a03eb4b589ded0bfd9671" => :mojave
    sha256 "965706f668855aaf4cf797b248d3a2522f559be02bd472f2bc280255c0d9c046" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/".eslintrc.json").write("{}") # minimal config
    (testpath/"syntax-error.js").write("{}}")
    # https://eslint.org/docs/user-guide/command-line-interface#exit-codes
    output = shell_output("#{bin}/eslint syntax-error.js", 1)
    assert_match "Unexpected token }", output
  end
end
