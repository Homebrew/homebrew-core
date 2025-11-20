class GruntCli < Formula
  desc "JavaScript Task Runner"
  homepage "https://gruntjs.com/"
  url "https://registry.npmjs.org/grunt-cli/-/grunt-cli-1.5.0.tgz"
  sha256 "4f7f52cf9f3bc62ebc7ae60d2db5c7f896cb0915ad1202dab9285d6117d7536d"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "0c39a24d633b89cf96aa864478ab95418b1003408d92ecfa446719ff4751df24"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"package.json").write <<~JSON
      {
        "name": "grunt-homebrew-test",
        "version": "1.0.0",
        "devDependencies": {
          "grunt": ">=0.4.0"
        }
      }
    JSON

    (testpath/"Gruntfile.js").write <<~JAVASCRIPT
      module.exports = function(grunt) {
        grunt.registerTask("default", "Write output to file.", function() {
          grunt.file.write("output.txt", "Success!");
        })
      };
    JAVASCRIPT

    system "npm", "install", *std_npm_args(prefix: false)
    system bin/"grunt"
    assert_path_exists testpath/"output.txt", "output.txt was not generated"
  end
end
