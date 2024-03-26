require "language/node"

class NpmCheckUpdates < Formula
  desc "Find newer versions of dependencies than what your package.json allows"
  homepage "https://github.com/raineorshine/npm-check-updates"
  url "https://registry.npmjs.org/npm-check-updates/-/npm-check-updates-16.14.18.tgz"
  sha256 "6b8435ef4003f3a1f8fe90ffe878bcfaa4dcf632031d8e2dca5352fbcbc0d34d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2fe4d65512d5d137c43f19a0d50eaf27ec883c28ad1ddfb0603aeedd62b1d7da"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2fe4d65512d5d137c43f19a0d50eaf27ec883c28ad1ddfb0603aeedd62b1d7da"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2fe4d65512d5d137c43f19a0d50eaf27ec883c28ad1ddfb0603aeedd62b1d7da"
    sha256 cellar: :any_skip_relocation, sonoma:         "5267e14fff8e47eee2e3dbd0a42d1dc1df37eb9ae69d8580aa80b13ddd380214"
    sha256 cellar: :any_skip_relocation, ventura:        "5267e14fff8e47eee2e3dbd0a42d1dc1df37eb9ae69d8580aa80b13ddd380214"
    sha256 cellar: :any_skip_relocation, monterey:       "5267e14fff8e47eee2e3dbd0a42d1dc1df37eb9ae69d8580aa80b13ddd380214"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2fe4d65512d5d137c43f19a0d50eaf27ec883c28ad1ddfb0603aeedd62b1d7da"
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
