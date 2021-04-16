require "language/node"

class GruntCli < Formula
  desc "JavaScript Task Runner"
  homepage "https://gruntjs.com/"
  url "https://registry.npmjs.org/grunt-cli/-/grunt-cli-1.4.2.tgz"
  sha256 "27e8008b092a6107d8b1074e33492f1a940eef7db6151d6fab04329c9ce5eb76"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6ec47d9e1a5db09d2c82fcf6cc1151deacab89b8598a229c30f15834ea322ded"
    sha256 cellar: :any_skip_relocation, big_sur:       "08b79a5bf9fc841e91228912273b55ccc280fe8eca50f11abf9d347a431ee786"
    sha256 cellar: :any_skip_relocation, catalina:      "923ae552d37cc07daf01370b8a0a631b90010b8f39a2e9d59dfeb57a1cdb020a"
    sha256 cellar: :any_skip_relocation, mojave:        "62e7fe43b28c574ff3f46df1c3023530dae81d9e1fcae91e276779893a330bf6"
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
