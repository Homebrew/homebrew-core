require "language/node"

class GruntCli < Formula
  desc "JavaScript Task Runner"
  homepage "https://gruntjs.com/"
  url "https://registry.npmjs.org/grunt-cli/-/grunt-cli-1.3.2.tgz"
  sha256 "3b0a3c2aee71f1cb92984afd3fffa7882cbd40958825313946aa7f2938f67e93"

  bottle do
    cellar :any_skip_relocation
    sha256 "1e3ab1d1b423cbbea629afa86caf1bd60d1988cd33e356fa1b9d8be2503b8a77" => :mojave
    sha256 "f863a44ad1095e592b36493171143c99a7187bc83325d312b9059400c06b2b9d" => :high_sierra
    sha256 "bc83b14e511d552cf9858264525b962a854a2d6c15512c468b1b5dc80b9d597d" => :sierra
    sha256 "e90e6ebd81896e57a481fb454fb2cb7e25e0e98baa9fab4c05ef71a3b7a00664" => :el_capitan
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"package.json").write <<~EOS
      {
        "name": "grunt-homebrew-test",
        "version": "1.0.0",
        "devDependencies": {
          "grunt": ">=0.4.0"
        }
      }
    EOS

    (testpath/"Gruntfile.js").write <<~EOS
      module.exports = function(grunt) {
        grunt.registerTask("default", "Write output to file.", function() {
          grunt.file.write("output.txt", "Success!");
        })
      };
    EOS

    system "npm", "install", *Language::Node.local_npm_install_args
    system bin/"grunt"
    assert_predicate testpath/"output.txt", :exist?, "output.txt was not generated"
  end
end
