class AddonsLinter < Formula
  desc "Firefox Add-ons linter, written in JavaScript"
  homepage "https://github.com/mozilla/addons-linter"
  url "https://registry.npmjs.org/addons-linter/-/addons-linter-7.13.0.tgz"
  sha256 "465faac15bc050894113b57dbcabf8abcc63240366f309c94f4bfab07eb1b414"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5f08c19e0418c13d38ef542ed8b07c649c1c08aac568559ca84d8f719870f3e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5f08c19e0418c13d38ef542ed8b07c649c1c08aac568559ca84d8f719870f3e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d5f08c19e0418c13d38ef542ed8b07c649c1c08aac568559ca84d8f719870f3e"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd61842b2e81d2c6cfd32149f61b6c6c77f74b37f1de6ec57105c59e7d7ec31b"
    sha256 cellar: :any_skip_relocation, ventura:       "cd61842b2e81d2c6cfd32149f61b6c6c77f74b37f1de6ec57105c59e7d7ec31b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d5f08c19e0418c13d38ef542ed8b07c649c1c08aac568559ca84d8f719870f3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5f08c19e0418c13d38ef542ed8b07c649c1c08aac568559ca84d8f719870f3e"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/addons-linter --version")

    (testpath/"manifest.json").write <<~JSON
      {
        "manifest_version": 2,
        "name": "Test Addon",
        "version": "1.0",
        "description": "A test addon",
        "applications": {
          "gecko": {
            "id": "test-addon@example.com"
          }
        }
      }
    JSON

    output = shell_output("#{bin}/addons-linter #{testpath}/manifest.json 2>&1")
    assert_match "BAD_ZIPFILE   Corrupt ZIP", output
  end
end
