require "language/node"

class NpmCheckUpdates < Formula
  desc "Find newer versions of dependencies than what your package.json allows"
  homepage "https://github.com/raineorshine/npm-check-updates"
  url "https://registry.npmjs.org/npm-check-updates/-/npm-check-updates-16.14.17.tgz"
  sha256 "be8d4661267ff6e338816064e61ecf9ef206bd8a0cbfa2133bb69f6d17e6d555"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "640bbf667806160130010ad285e89c27135d09afe8f4fa8be126933a34ff8774"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "640bbf667806160130010ad285e89c27135d09afe8f4fa8be126933a34ff8774"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "640bbf667806160130010ad285e89c27135d09afe8f4fa8be126933a34ff8774"
    sha256 cellar: :any_skip_relocation, sonoma:         "4b52c668beee2d16463ec3f9f7439f984921461593ff097e094247be3f7fdef4"
    sha256 cellar: :any_skip_relocation, ventura:        "4b52c668beee2d16463ec3f9f7439f984921461593ff097e094247be3f7fdef4"
    sha256 cellar: :any_skip_relocation, monterey:       "4b52c668beee2d16463ec3f9f7439f984921461593ff097e094247be3f7fdef4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "640bbf667806160130010ad285e89c27135d09afe8f4fa8be126933a34ff8774"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    test_package_json = testpath/"package.json"
    test_package_json.write <<~EOS
      {
        "dependencies": {
          "express": "1.8.7",
          "lodash": "3.6.1"
        }
      }
    EOS

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
