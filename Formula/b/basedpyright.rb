class Basedpyright < Formula
  desc "Pyright fork with various improvements and built-in pylance features"
  homepage "https://github.com/DetachHead/basedpyright"
  url "https://registry.npmjs.org/basedpyright/-/basedpyright-1.28.5.tgz"
  sha256 "4a218b86d151d4da7016cf1991252d6c25d7e8f1e2d717b216229c3d6fb74657"
  license "MIT"
  head "https://github.com/detachhead/basedpyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5faec8b287830a15ca5885e1d21bb5fc237aa2065d3d8d00b892d673eca7e4bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5faec8b287830a15ca5885e1d21bb5fc237aa2065d3d8d00b892d673eca7e4bb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5faec8b287830a15ca5885e1d21bb5fc237aa2065d3d8d00b892d673eca7e4bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed7c06bc33e5a52999486c4f8933dd17bfbd34681d3228bc0fc9fb4f7a6451a2"
    sha256 cellar: :any_skip_relocation, ventura:       "ed7c06bc33e5a52999486c4f8933dd17bfbd34681d3228bc0fc9fb4f7a6451a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5faec8b287830a15ca5885e1d21bb5fc237aa2065d3d8d00b892d673eca7e4bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5faec8b287830a15ca5885e1d21bb5fc237aa2065d3d8d00b892d673eca7e4bb"
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
