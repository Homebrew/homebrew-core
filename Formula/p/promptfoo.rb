require "language/node"

class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.58.0.tgz"
  sha256 "219eabc815e92b9f6e6092c262b9f1447f0ba3be23fd5ba882b0c95a99769dca"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f854a1fab1b2000a59e3030579890af002dd73f68ecce2902b55a3c408780482"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ef106a50ad40048910c8324ff6ddd228be9d343d7942b99c5c77291db694f56e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b38c2d23668f100b28ef26de328e7095c8bd995f7e7d70e1630c6a0ecae1e7e7"
    sha256 cellar: :any_skip_relocation, sonoma:         "3fab01a6e5262f1ade85e40aef273885cb0080ea76e8feab4179cdec10f4f648"
    sha256 cellar: :any_skip_relocation, ventura:        "30394f6c0467be0de9de532fb1e4937d6157191dda041a36f97c9b38741f793c"
    sha256 cellar: :any_skip_relocation, monterey:       "c4a777d7338378e19f759ec95c975c33a0fd89463dc6bcf9850d780f181b129c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "518e74780f4575763506cc2c0a45a0f93e7f3d9cde0560d2ca01fec0ed50a7d8"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"promptfoo", "init"
    assert_predicate testpath/".promptfoo", :exist?
    assert_match "description: 'My first eval'", (testpath/"promptfooconfig.yaml").read

    assert_match version.to_s, shell_output("#{bin}/promptfoo --version", 1)
  end
end
