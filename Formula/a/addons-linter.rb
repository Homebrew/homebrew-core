class AddonsLinter < Formula
  desc "Firefox Add-ons linter, written in JavaScript"
  homepage "https://github.com/mozilla/addons-linter"
  url "https://registry.npmjs.org/addons-linter/-/addons-linter-10.16.0.tgz"
  sha256 "e16ef6d4ff9fdcdfd79ced0c755ce9b039b18d7d8bdb8602546d861ddb3c1863"
  license "MPL-2.0"

  bottle do
    manifest_sha256 "6fbc098034ada8912ff961ddda89eceef061a589fe2bb89ed3e9726db701edab"
    sha256 cellar: :any_skip_relocation, all: "b1a4243e296f5e2f175c4f1ce588efb461a5ad7ac5e33075c55b143009b41e95"
  end

  depends_on "node"

  allow_network_access! :build

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
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
