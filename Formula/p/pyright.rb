class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.400.tgz"
  sha256 "2ccba7af9c8b14bb81c8fa9bb558d8b5181b586ec4dfc448b78eb4209e7a429a"
  license "MIT"
  head "https://github.com/microsoft/pyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c6c6bc2be25115565840bed82c24bce19606cab80d3a2eda9c0bf6d5a70e77b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c6c6bc2be25115565840bed82c24bce19606cab80d3a2eda9c0bf6d5a70e77b5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c6c6bc2be25115565840bed82c24bce19606cab80d3a2eda9c0bf6d5a70e77b5"
    sha256 cellar: :any_skip_relocation, sonoma:        "1929d9048610b09e242de322cd0d1017aeac20b47f658006b22e4a5891f395ad"
    sha256 cellar: :any_skip_relocation, ventura:       "1929d9048610b09e242de322cd0d1017aeac20b47f658006b22e4a5891f395ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c6c6bc2be25115565840bed82c24bce19606cab80d3a2eda9c0bf6d5a70e77b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6c6bc2be25115565840bed82c24bce19606cab80d3a2eda9c0bf6d5a70e77b5"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"broken.py").write <<~PYTHON
      def wrong_types(a: int, b: int) -> str:
          return a + b
    PYTHON
    output = pipe_output("#{bin}/pyright broken.py 2>&1")
    assert_match "error: Type \"int\" is not assignable to return type \"str\"", output
  end
end
