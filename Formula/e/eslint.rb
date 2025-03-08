class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-9.22.0.tgz"
  sha256 "20782c780ca3819849d699e74a3715bb02512cb21de20dec855334756229ec8c"
  license "MIT"
  head "https://github.com/eslint/eslint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5936867b91afdc7c631746f6d86ff34e9d23d516abca8975fa937c5d4c282da0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5936867b91afdc7c631746f6d86ff34e9d23d516abca8975fa937c5d4c282da0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5936867b91afdc7c631746f6d86ff34e9d23d516abca8975fa937c5d4c282da0"
    sha256 cellar: :any_skip_relocation, sonoma:        "7529c21b0fac0d94552f5afe55c4cb708877cbd56e983641c9e6a60a37a420e2"
    sha256 cellar: :any_skip_relocation, ventura:       "7529c21b0fac0d94552f5afe55c4cb708877cbd56e983641c9e6a60a37a420e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5936867b91afdc7c631746f6d86ff34e9d23d516abca8975fa937c5d4c282da0"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    # https://eslint.org/docs/latest/use/configure/configuration-files#configuration-file
    (testpath/"eslint.config.js").write("{}") # minimal config
    (testpath/"syntax-error.js").write("{}}")

    # https://eslint.org/docs/user-guide/command-line-interface#exit-codes
    output = shell_output("#{bin}/eslint syntax-error.js", 1)
    assert_match "Unexpected token }", output
  end
end
