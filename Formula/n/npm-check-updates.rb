class NpmCheckUpdates < Formula
  desc "Find newer versions of dependencies than what your package.json allows"
  homepage "https://github.com/raineorshine/npm-check-updates"
  url "https://registry.npmjs.org/npm-check-updates/-/npm-check-updates-17.0.6.tgz"
  sha256 "125ead32a5b12f2bd38814b98e92b9bae1c0811a9c8ce5bc31a02fb306a194ab"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "587484937d9e77e3a0e315a0f4f2f4c3fce5158eaf55a871d4e26a892d58aff1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "587484937d9e77e3a0e315a0f4f2f4c3fce5158eaf55a871d4e26a892d58aff1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "587484937d9e77e3a0e315a0f4f2f4c3fce5158eaf55a871d4e26a892d58aff1"
    sha256 cellar: :any_skip_relocation, sonoma:         "deb9fcf496473cae60dbb60d407d84f4159cfbf4338c2d6956c0c1320cd187a1"
    sha256 cellar: :any_skip_relocation, ventura:        "deb9fcf496473cae60dbb60d407d84f4159cfbf4338c2d6956c0c1320cd187a1"
    sha256 cellar: :any_skip_relocation, monterey:       "deb9fcf496473cae60dbb60d407d84f4159cfbf4338c2d6956c0c1320cd187a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "587484937d9e77e3a0e315a0f4f2f4c3fce5158eaf55a871d4e26a892d58aff1"
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
