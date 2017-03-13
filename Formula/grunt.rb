require "language/node"

class Grunt < Formula
  desc "JavaScript Task Runner"
  homepage "https://gruntjs.com/"
  url "https://registry.npmjs.org/grunt-cli/-/grunt-cli-1.2.0.tgz"
  sha256 "fdb1d4bd83435b3f70614b608e0027a0d75ebfda151396bb99c46405334a01d8"

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"package.json").write <<-EOS.undent
    {
      "name": "grunt-homebrew-test",
      "version": "1.0.0",
      "devDependencies": {
        "grunt": ">=0.4.0"
      }
    }
    EOS

    (testpath/"Gruntfile.js").write <<-EOS.undent
    module.exports = function(grunt) {
      grunt.registerTask("default", "Write output to file.", function() {
        grunt.file.write("output.txt", "Success!");
      })
    };
    EOS

    system "npm", "install", *Language::Node.local_npm_install_args
    system bin/"grunt"
    assert File.exist?("output.txt"), "output.txt was not generated"
  end
end
