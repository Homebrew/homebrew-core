class Basedpyright < Formula
  desc "Pyright fork with various improvements and built-in pylance features"
  homepage "https://github.com/DetachHead/basedpyright"
  url "https://registry.npmjs.org/basedpyright/-/basedpyright-1.16.0.tgz"
  sha256 "563b2f94edaac311e46326c311801d5c4dee78893e60efa02dd0487058630e9a"
  license "MIT"
  head "https://github.com/detachhead/basedpyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ca98db196e51c2f3dc9395a7fef9f759909a93588262a05f7c99842d2b959789"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ca98db196e51c2f3dc9395a7fef9f759909a93588262a05f7c99842d2b959789"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca98db196e51c2f3dc9395a7fef9f759909a93588262a05f7c99842d2b959789"
    sha256 cellar: :any_skip_relocation, sonoma:         "459345fb829ded647d8179d6ddcfbb1797e64b8d01bc6b90c27281151a323baa"
    sha256 cellar: :any_skip_relocation, ventura:        "459345fb829ded647d8179d6ddcfbb1797e64b8d01bc6b90c27281151a323baa"
    sha256 cellar: :any_skip_relocation, monterey:       "459345fb829ded647d8179d6ddcfbb1797e64b8d01bc6b90c27281151a323baa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca98db196e51c2f3dc9395a7fef9f759909a93588262a05f7c99842d2b959789"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec/"bin/pyright" => "basedpyright"
    bin.install_symlink libexec/"bin/pyright-langserver" => "basedpyright-langserver"
  end

  test do
    (testpath/"broken.py").write <<~EOS
      def wrong_types(a: int, b: int) -> str:
          return a + b
    EOS
    output = pipe_output("#{bin}/basedpyright broken.py 2>&1")
    assert_match 'error: Expression of type "int" is incompatible with return type "str"', output
  end
end
