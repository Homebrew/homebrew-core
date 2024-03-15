require "language/node"

class NpmCheckUpdates < Formula
  desc "Find newer versions of dependencies than what your package.json allows"
  homepage "https://github.com/raineorshine/npm-check-updates"
  url "https://registry.npmjs.org/npm-check-updates/-/npm-check-updates-16.14.16.tgz"
  sha256 "7b1bdf22b7a894ebe8870a68d9d7e0d6c9081ac2c9ed4a7b14d36872a4e700a7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cbd7b9786596db9aacbb0223f4bc91957b84612dcfec503b52ccf91df19835cc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cbd7b9786596db9aacbb0223f4bc91957b84612dcfec503b52ccf91df19835cc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cbd7b9786596db9aacbb0223f4bc91957b84612dcfec503b52ccf91df19835cc"
    sha256 cellar: :any_skip_relocation, sonoma:         "05c895f9db10f7d9dd4e4499c87f71457c149563c47c2798ff56a53d8e10c030"
    sha256 cellar: :any_skip_relocation, ventura:        "05c895f9db10f7d9dd4e4499c87f71457c149563c47c2798ff56a53d8e10c030"
    sha256 cellar: :any_skip_relocation, monterey:       "05c895f9db10f7d9dd4e4499c87f71457c149563c47c2798ff56a53d8e10c030"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cbd7b9786596db9aacbb0223f4bc91957b84612dcfec503b52ccf91df19835cc"
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
