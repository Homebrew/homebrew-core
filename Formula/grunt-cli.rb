require "language/node"

class GruntCli < Formula
  desc "JavaScript Task Runner"
  homepage "https://gruntjs.com/"
  url "https://registry.npmjs.org/grunt-cli/-/grunt-cli-1.3.2.tgz"
  sha256 "3b0a3c2aee71f1cb92984afd3fffa7882cbd40958825313946aa7f2938f67e93"

  bottle do
    cellar :any_skip_relocation
    sha256 "738d87cf6f7eb5a0b554980f1e77dc349fa092d34ef20b2f41583442d9249348" => :mojave
    sha256 "7df2a65c82959d478c0d384ad5e51046186750e0f744beea06916c663c4ca4eb" => :high_sierra
    sha256 "677a92a25a3f7d1a8e6ceeb6b869e4f4d784bbd10a32e37d7f32aa122c1176a4" => :sierra
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
