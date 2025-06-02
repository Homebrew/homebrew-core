class GulpCli < Formula
  desc "Command-line utility for Gulp"
  homepage "https://github.com/gulpjs/gulp-cli"
  url "https://registry.npmjs.org/gulp-cli/-/gulp-cli-3.1.0.tgz"
  sha256 "683fa88d8d15b49a8adf760f25e4e46f068f1e065fe234e1199b27fe6bf0376e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "240302d96e2d2ded3a74ad80abc51db6c8539e32421a6026a081879c1387dc3c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "240302d96e2d2ded3a74ad80abc51db6c8539e32421a6026a081879c1387dc3c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "240302d96e2d2ded3a74ad80abc51db6c8539e32421a6026a081879c1387dc3c"
    sha256 cellar: :any_skip_relocation, sonoma:        "353b3d0218f3d9fd50d85868af51173ff261ced09ec71e73be07229331b0ce6c"
    sha256 cellar: :any_skip_relocation, ventura:       "353b3d0218f3d9fd50d85868af51173ff261ced09ec71e73be07229331b0ce6c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "240302d96e2d2ded3a74ad80abc51db6c8539e32421a6026a081879c1387dc3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "240302d96e2d2ded3a74ad80abc51db6c8539e32421a6026a081879c1387dc3c"
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
