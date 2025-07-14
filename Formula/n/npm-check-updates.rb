class NpmCheckUpdates < Formula
  desc "Find newer versions of dependencies than what your package.json allows"
  homepage "https://github.com/raineorshine/npm-check-updates"
  url "https://registry.npmjs.org/npm-check-updates/-/npm-check-updates-18.0.1.tgz"
  sha256 "78acf53174831af4e208f469a90242d277990bec0a356d408566cad182fa5f83"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "488928229409efa74b0cb47e1b91fe2b7e907471276f3a852e6f5982062a0abe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "488928229409efa74b0cb47e1b91fe2b7e907471276f3a852e6f5982062a0abe"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "488928229409efa74b0cb47e1b91fe2b7e907471276f3a852e6f5982062a0abe"
    sha256 cellar: :any_skip_relocation, sonoma:        "26edec4b36c15b232b4e30e205cd6aa938dd474e94b4c41f781e47ab46d1939d"
    sha256 cellar: :any_skip_relocation, ventura:       "26edec4b36c15b232b4e30e205cd6aa938dd474e94b4c41f781e47ab46d1939d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "488928229409efa74b0cb47e1b91fe2b7e907471276f3a852e6f5982062a0abe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "488928229409efa74b0cb47e1b91fe2b7e907471276f3a852e6f5982062a0abe"
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
