class NpmCheckUpdates < Formula
  desc "Find newer versions of dependencies than what your package.json allows"
  homepage "https://github.com/raineorshine/npm-check-updates"
  url "https://registry.npmjs.org/npm-check-updates/-/npm-check-updates-17.1.18.tgz"
  sha256 "9d3baba99d82d33ac8609743ffe2efe5e3b23e42283e9f0e410332d915050787"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7324824d8ddffc2f778cef51907e4ca24c26c0039d6d7c05241d639bf847c78e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7324824d8ddffc2f778cef51907e4ca24c26c0039d6d7c05241d639bf847c78e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7324824d8ddffc2f778cef51907e4ca24c26c0039d6d7c05241d639bf847c78e"
    sha256 cellar: :any_skip_relocation, sonoma:        "723cd78e5b12277ce8cd3d0d3137fd9c526a78fcfd09097cd7805298a3bbf808"
    sha256 cellar: :any_skip_relocation, ventura:       "723cd78e5b12277ce8cd3d0d3137fd9c526a78fcfd09097cd7805298a3bbf808"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7324824d8ddffc2f778cef51907e4ca24c26c0039d6d7c05241d639bf847c78e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7324824d8ddffc2f778cef51907e4ca24c26c0039d6d7c05241d639bf847c78e"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    test_package_json = testpath/"package.json"
    test_package_json.write <<~JSON
      {
        "dependencies": {
          "express": "1.8.7",
          "lodash": "3.6.1"
        }
      }
    JSON

    system bin/"ncu", "-u"

    # Read the updated package.json to get the new dependency versions
    updated_package_json = JSON.parse(test_package_json.read)
    updated_express_version = updated_package_json["dependencies"]["express"]
    updated_lodash_version = updated_package_json["dependencies"]["lodash"]

    # Assert that both dependencies have been updated to higher versions
    assert Gem::Version.new(updated_express_version) > Gem::Version.new("1.8.7"),
      "Express version not updated as expected"
    assert Gem::Version.new(updated_lodash_version) > Gem::Version.new("3.6.1"),
      "Lodash version not updated as expected"
  end
end
