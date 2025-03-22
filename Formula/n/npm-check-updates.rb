class NpmCheckUpdates < Formula
  desc "Find newer versions of dependencies than what your package.json allows"
  homepage "https://github.com/raineorshine/npm-check-updates"
  url "https://registry.npmjs.org/npm-check-updates/-/npm-check-updates-17.1.16.tgz"
  sha256 "dbcc9daafe7468288cdd3f390de7352d76dd6ce4d20fb644577f1684ab343a30"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "776b665e31be562e426fb4a1149517b1ceb442b0840a8d65e8dc60c918e5f82c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "776b665e31be562e426fb4a1149517b1ceb442b0840a8d65e8dc60c918e5f82c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "776b665e31be562e426fb4a1149517b1ceb442b0840a8d65e8dc60c918e5f82c"
    sha256 cellar: :any_skip_relocation, sonoma:        "d27588b143e4d1d4d558bc2752d1aef793b9fcd278076e0317bc7c56b877f314"
    sha256 cellar: :any_skip_relocation, ventura:       "d27588b143e4d1d4d558bc2752d1aef793b9fcd278076e0317bc7c56b877f314"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "776b665e31be562e426fb4a1149517b1ceb442b0840a8d65e8dc60c918e5f82c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "776b665e31be562e426fb4a1149517b1ceb442b0840a8d65e8dc60c918e5f82c"
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
