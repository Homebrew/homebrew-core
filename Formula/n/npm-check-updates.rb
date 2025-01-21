class NpmCheckUpdates < Formula
  desc "Find newer versions of dependencies than what your package.json allows"
  homepage "https://github.com/raineorshine/npm-check-updates"
  url "https://registry.npmjs.org/npm-check-updates/-/npm-check-updates-17.1.14.tgz"
  sha256 "4d6d8f73aeb7fb7db28bec3640bf70e0bb8ed190ae6bc1bb40337c431e28b44c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70216dedf167fb43b9571e82588e6dac49632cf5f3106365fc4a6964e5fcdecd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "70216dedf167fb43b9571e82588e6dac49632cf5f3106365fc4a6964e5fcdecd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "70216dedf167fb43b9571e82588e6dac49632cf5f3106365fc4a6964e5fcdecd"
    sha256 cellar: :any_skip_relocation, sonoma:        "079eb7c988be53219f9f3aee8aa83bfaa60cf962c637fafc31ecd6d18bca524f"
    sha256 cellar: :any_skip_relocation, ventura:       "079eb7c988be53219f9f3aee8aa83bfaa60cf962c637fafc31ecd6d18bca524f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70216dedf167fb43b9571e82588e6dac49632cf5f3106365fc4a6964e5fcdecd"
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
