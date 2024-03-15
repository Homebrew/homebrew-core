require "language/node"

class NpmCheckUpdates < Formula
  desc "Find newer versions of dependencies than what your package.json allows"
  homepage "https://github.com/raineorshine/npm-check-updates"
  url "https://registry.npmjs.org/npm-check-updates/-/npm-check-updates-16.14.16.tgz"
  sha256 "7b1bdf22b7a894ebe8870a68d9d7e0d6c9081ac2c9ed4a7b14d36872a4e700a7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1f919cc20d95454be2d3953b087036c6aa11dab36c459b3baf81dd8c42a9e5a6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1f919cc20d95454be2d3953b087036c6aa11dab36c459b3baf81dd8c42a9e5a6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f919cc20d95454be2d3953b087036c6aa11dab36c459b3baf81dd8c42a9e5a6"
    sha256 cellar: :any_skip_relocation, sonoma:         "aee491cc5b7990900c363b48ec56171aefb518dbc569d3896cd20d73e2b86ba7"
    sha256 cellar: :any_skip_relocation, ventura:        "aee491cc5b7990900c363b48ec56171aefb518dbc569d3896cd20d73e2b86ba7"
    sha256 cellar: :any_skip_relocation, monterey:       "aee491cc5b7990900c363b48ec56171aefb518dbc569d3896cd20d73e2b86ba7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f919cc20d95454be2d3953b087036c6aa11dab36c459b3baf81dd8c42a9e5a6"
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
