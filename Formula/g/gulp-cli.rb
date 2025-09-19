class GulpCli < Formula
  desc "Command-line utility for Gulp"
  homepage "https://github.com/gulpjs/gulp-cli"
  url "https://registry.npmjs.org/gulp-cli/-/gulp-cli-3.1.0.tgz"
  sha256 "683fa88d8d15b49a8adf760f25e4e46f068f1e065fe234e1199b27fe6bf0376e"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "240302d96e2d2ded3a74ad80abc51db6c8539e32421a6026a081879c1387dc3c"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "npm", "init", "-y"
    system "npm", "install", *std_npm_args(prefix: false), "gulp"

    output = shell_output("#{bin}/gulp --version")
    assert_match "CLI version: #{version}", output
    assert_match "Local version: ", output

    (testpath/"gulpfile.js").write <<~JS
      function defaultTask(cb) {
        cb();
      }
      exports.default = defaultTask
    JS
    assert_match "Finished 'default' after ", shell_output("#{bin}/gulp")
  end
end
