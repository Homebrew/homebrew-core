require "language/node"

class GruntCli < Formula
  desc "JavaScript Task Runner"
  homepage "https://gruntjs.com/"
  url "https://registry.npmjs.org/grunt-cli/-/grunt-cli-1.2.0.tgz"
  sha256 "fdb1d4bd83435b3f70614b608e0027a0d75ebfda151396bb99c46405334a01d8"

  bottle do
    cellar :any_skip_relocation
    sha256 "418c56ce7e11dde5606e3e0d01ff93051af7d9391940dddb75cbb480cd9f3837" => :sierra
    sha256 "b2d83d0d16fc8e9545d34bf57f3f21902639693df09a4d1ad0ecdc911c29d9a5" => :el_capitan
    sha256 "8e1da144c2febcbde826b802f1110c25e27dd1d8a534f19a7171fcf88227a7e0" => :yosemite
  end

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
