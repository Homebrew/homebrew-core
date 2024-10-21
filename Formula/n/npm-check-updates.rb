class NpmCheckUpdates < Formula
  desc "Find newer versions of dependencies than what your package.json allows"
  homepage "https://github.com/raineorshine/npm-check-updates"
  url "https://registry.npmjs.org/npm-check-updates/-/npm-check-updates-17.1.4.tgz"
  sha256 "0dd5adab51e033dab4f5c2a7f9097cec2a9ff704c5933a1a34afaee695370e66"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "206d0abffc40c2289ae8c5ccdc73e23b5ebe4dc274f294b1bd34f85c99af2402"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "206d0abffc40c2289ae8c5ccdc73e23b5ebe4dc274f294b1bd34f85c99af2402"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "206d0abffc40c2289ae8c5ccdc73e23b5ebe4dc274f294b1bd34f85c99af2402"
    sha256 cellar: :any_skip_relocation, sonoma:        "f7f6bf52e2462ade92160246aed55ed882670343ae273183b370fe1340647c0b"
    sha256 cellar: :any_skip_relocation, ventura:       "f7f6bf52e2462ade92160246aed55ed882670343ae273183b370fe1340647c0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "206d0abffc40c2289ae8c5ccdc73e23b5ebe4dc274f294b1bd34f85c99af2402"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
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
