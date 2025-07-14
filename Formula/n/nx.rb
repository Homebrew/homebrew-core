class Nx < Formula
  desc "Smart, Fast and Extensible Build System"
  homepage "https://nx.dev"
  url "https://registry.npmjs.org/nx/-/nx-21.2.3.tgz"
  sha256 "466d635fe906226d2c174cb8be0c957ac3a64415b6f988ca6064164d9c3f7fbb"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "474bb59ad55f2da0dbc74406204653273fe0bf35ac3de4922b8875af8aae2bb2"
    sha256 cellar: :any,                 arm64_sonoma:  "474bb59ad55f2da0dbc74406204653273fe0bf35ac3de4922b8875af8aae2bb2"
    sha256 cellar: :any,                 arm64_ventura: "474bb59ad55f2da0dbc74406204653273fe0bf35ac3de4922b8875af8aae2bb2"
    sha256 cellar: :any,                 sonoma:        "03c77f932fce29bee75da0c8205812556b75518d6753af7c2ed86e661df7c558"
    sha256 cellar: :any,                 ventura:       "03c77f932fce29bee75da0c8205812556b75518d6753af7c2ed86e661df7c558"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c5c388b96318fb5310f9f1e079f016071a0a29f69effd864851a763eb858bfa4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae64a7ab88eb1e9107ca37af7af7c558ff75eeecf723128e3f06bff8db31f1f8"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"package.json").write <<~JSON
      {
        "name": "@acme/repo",
        "version": "0.0.1",
        "scripts": {
          "test": "echo 'Tests passed'"
        }
      }
    JSON

    system bin/"nx", "init", "--no-interactive"
    assert_path_exists testpath/"nx.json"

    output = shell_output("#{bin}/nx 'test'")
    assert_match "Successfully ran target test", output
  end
end
