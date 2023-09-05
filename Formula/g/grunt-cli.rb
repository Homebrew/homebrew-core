require "language/node"

class GruntCli < Formula
  desc "JavaScript Task Runner"
  homepage "https://gruntjs.com/"
  url "https://registry.npmjs.org/grunt-cli/-/grunt-cli-1.4.3.tgz"
  sha256 "c7ffc367ad7d019ef34e98913dfdbcf05dcf03f2e32dc88fba8f650b1dae83bd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7e878a48df0184f262a7d4a0d4967b7623f9327e29206faaf90758664de3dd19"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "38f67054b492a11847be41d443b32c017fdbb9b94265ce42299675ea8742ef99"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8eafad607c94848c1bd74eca2a52b92533f399247c85d4de923ff12367ce2cda"
    sha256 cellar: :any_skip_relocation, ventura:        "1caa9aaf12306e326ffeabc633855bec97c1a537506d8bc09a88a8869e4fd909"
    sha256 cellar: :any_skip_relocation, monterey:       "af276cc7570d11abe7da586cc0dfcee75947df3b58bcd29892722d8654649668"
    sha256 cellar: :any_skip_relocation, big_sur:        "e1be76f2bb72f2cc111627400cf586487b8515a0051b96c4d8138da773d1ac73"
    sha256 cellar: :any_skip_relocation, catalina:       "e1be76f2bb72f2cc111627400cf586487b8515a0051b96c4d8138da773d1ac73"
    sha256 cellar: :any_skip_relocation, mojave:         "e1be76f2bb72f2cc111627400cf586487b8515a0051b96c4d8138da773d1ac73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b45f26c253f18a68abd0e318d4a5634d371cace863b5b086fc8187d05ee5f5f7"
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
