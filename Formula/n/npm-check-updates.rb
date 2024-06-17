require "language/node"

class NpmCheckUpdates < Formula
  desc "Find newer versions of dependencies than what your package.json allows"
  homepage "https://github.com/raineorshine/npm-check-updates"
  url "https://registry.npmjs.org/npm-check-updates/-/npm-check-updates-16.14.20.tgz"
  sha256 "cd17eab112d418e8b8e75695700457e2169b9a504b32acba68a27d76edb08076"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "abf83466549d4954a2f7c88e394bf266270ed2a0cc00798e60b2c89b281828e9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "abf83466549d4954a2f7c88e394bf266270ed2a0cc00798e60b2c89b281828e9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "abf83466549d4954a2f7c88e394bf266270ed2a0cc00798e60b2c89b281828e9"
    sha256 cellar: :any_skip_relocation, sonoma:         "c4e530699442be6a0ab7069ab922e24362c7f5c29c5bcd2b95c4f1d235671ae1"
    sha256 cellar: :any_skip_relocation, ventura:        "c4e530699442be6a0ab7069ab922e24362c7f5c29c5bcd2b95c4f1d235671ae1"
    sha256 cellar: :any_skip_relocation, monterey:       "c4e530699442be6a0ab7069ab922e24362c7f5c29c5bcd2b95c4f1d235671ae1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "abf83466549d4954a2f7c88e394bf266270ed2a0cc00798e60b2c89b281828e9"
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
