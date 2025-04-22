class Basedpyright < Formula
  desc "Pyright fork with various improvements and built-in pylance features"
  homepage "https://github.com/DetachHead/basedpyright"
  url "https://registry.npmjs.org/basedpyright/-/basedpyright-1.29.0.tgz"
  sha256 "b3636ddec4aeae195f76d96dde73aa315092315d8ba7259ef21bd5c7b753dcad"
  license "MIT"
  head "https://github.com/detachhead/basedpyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cca2816b6a35629e74a4134a6d1e63626202a710af027182186bbbcaa723d7e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cca2816b6a35629e74a4134a6d1e63626202a710af027182186bbbcaa723d7e0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cca2816b6a35629e74a4134a6d1e63626202a710af027182186bbbcaa723d7e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "2607b08556f44d22f36e75cb8e1401df5b93f6cb1c27eec72ff57478352f6af8"
    sha256 cellar: :any_skip_relocation, ventura:       "2607b08556f44d22f36e75cb8e1401df5b93f6cb1c27eec72ff57478352f6af8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cca2816b6a35629e74a4134a6d1e63626202a710af027182186bbbcaa723d7e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cca2816b6a35629e74a4134a6d1e63626202a710af027182186bbbcaa723d7e0"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec/"bin/pyright" => "basedpyright"
    bin.install_symlink libexec/"bin/pyright-langserver" => "basedpyright-langserver"
  end

  test do
    (testpath/"broken.py").write <<~PYTHON
      def wrong_types(a: int, b: int) -> str:
          return a + b
    PYTHON
    output = shell_output("#{bin}/basedpyright broken.py 2>&1", 1)
    assert_match "error: Type \"int\" is not assignable to return type \"str\"", output
  end
end
