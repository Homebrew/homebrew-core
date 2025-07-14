class AddonsLinter < Formula
  desc "Firefox Add-ons linter, written in JavaScript"
  homepage "https://github.com/mozilla/addons-linter"
  url "https://registry.npmjs.org/addons-linter/-/addons-linter-7.17.0.tgz"
  sha256 "f2f528beab8d2f3a1e61d6b4bd7b639b993e91844708cc946842c61b74039924"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9da46ec379c57c1fd7c94001555e6c74d9c414ddf36a036cfc837bfb22569e86"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9da46ec379c57c1fd7c94001555e6c74d9c414ddf36a036cfc837bfb22569e86"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9da46ec379c57c1fd7c94001555e6c74d9c414ddf36a036cfc837bfb22569e86"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd43e16e29dcf895544db836b46a466780a9a8476ffbf3642fcd066be5eb7f87"
    sha256 cellar: :any_skip_relocation, ventura:       "cd43e16e29dcf895544db836b46a466780a9a8476ffbf3642fcd066be5eb7f87"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9da46ec379c57c1fd7c94001555e6c74d9c414ddf36a036cfc837bfb22569e86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9da46ec379c57c1fd7c94001555e6c74d9c414ddf36a036cfc837bfb22569e86"
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
