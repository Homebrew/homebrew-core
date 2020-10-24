require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-7.12.0.tgz"
  sha256 "eb95a904e6deb4937b3ce473db891d10d17e8fbc146e92e3afd6eb6340d1a6bf"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "5e5c17351f44053f30e59029510abb3f834eb10b406cd4b9f6625ce535490270" => :catalina
    sha256 "c459dda58ac19bf26a1298a28de6cf34a0f05de290d0c181e5fd16bdcae86caf" => :mojave
    sha256 "2c9bdf660e74a6318353bc883a622abaf86e6589b8c141462704fff36b75bd3d" => :high_sierra
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
