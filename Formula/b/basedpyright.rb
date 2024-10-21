class Basedpyright < Formula
  desc "Pyright fork with various improvements and built-in pylance features"
  homepage "https://github.com/DetachHead/basedpyright"
  url "https://registry.npmjs.org/basedpyright/-/basedpyright-1.19.0.tgz"
  sha256 "3671593db9fda88b70fd46f94bd1072c5fbe4a88198d51e98f9f01a93c1f22fe"
  license "MIT"
  head "https://github.com/detachhead/basedpyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d50579e9b95bca1ab55181c4d69680104e2aae123a663025e375a9be0cf88378"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d50579e9b95bca1ab55181c4d69680104e2aae123a663025e375a9be0cf88378"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d50579e9b95bca1ab55181c4d69680104e2aae123a663025e375a9be0cf88378"
    sha256 cellar: :any_skip_relocation, sonoma:        "9eafd5ed2ca86de0e298e8956cfc9a873c75014a329d983132f35484e7ce4b91"
    sha256 cellar: :any_skip_relocation, ventura:       "9eafd5ed2ca86de0e298e8956cfc9a873c75014a329d983132f35484e7ce4b91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d50579e9b95bca1ab55181c4d69680104e2aae123a663025e375a9be0cf88378"
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
    assert_match "error: Type \"int\" is not assignable to return type \"str\"", output
  end
end
