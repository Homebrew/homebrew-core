class GruntCli < Formula
  desc "JavaScript Task Runner"
  homepage "https://gruntjs.com/"
  url "https://registry.npmjs.org/grunt-cli/-/grunt-cli-1.5.0.tgz"
  sha256 "4f7f52cf9f3bc62ebc7ae60d2db5c7f896cb0915ad1202dab9285d6117d7536d"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "6623c9c49be25c0d046324eae90919e3360542d69f9cf921b3cc47a44573c984"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2dd1c3cbca5634e0af5e6f0cdecde2700c3b28fef7995b59527cbc225cc133a7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2dd1c3cbca5634e0af5e6f0cdecde2700c3b28fef7995b59527cbc225cc133a7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2dd1c3cbca5634e0af5e6f0cdecde2700c3b28fef7995b59527cbc225cc133a7"
    sha256 cellar: :any_skip_relocation, sonoma:         "be6201a69eafbd7b9d93fa919cd410dc0c8e03eef63f686836690fdee13b9fe0"
    sha256 cellar: :any_skip_relocation, ventura:        "be6201a69eafbd7b9d93fa919cd410dc0c8e03eef63f686836690fdee13b9fe0"
    sha256 cellar: :any_skip_relocation, monterey:       "be6201a69eafbd7b9d93fa919cd410dc0c8e03eef63f686836690fdee13b9fe0"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "7cfb7579ba83a114818c2ef065a534f5d237cbd21b3be57d73063e5763addaa8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9383dff764eb6833c08ecf8ac67a869c40c5830ec27471577094357feabac56"
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
