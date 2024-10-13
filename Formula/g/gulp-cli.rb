class GulpCli < Formula
  desc "Command-line utility for Gulp"
  homepage "https://github.com/gulpjs/gulp-cli"
  url "https://registry.npmjs.org/gulp-cli/-/gulp-cli-3.0.0.tgz"
  sha256 "f90ba044fd1486dcc0f5e7ec07aba39fc62079cd0f3df78f2ba123b404f8094b"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "e4705be7a88b79dd85745a81118909d722e59a0d3d81a2766d5ee873b4f98089"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b6b78b8a649dc8b662a2fa39814d039991950450e52b20692ff9756955f642d6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b6b78b8a649dc8b662a2fa39814d039991950450e52b20692ff9756955f642d6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b6b78b8a649dc8b662a2fa39814d039991950450e52b20692ff9756955f642d6"
    sha256 cellar: :any_skip_relocation, sonoma:         "97e82d635666e3f778dd12285f8881701110370eaefe6c22fb902b493ae2ba58"
    sha256 cellar: :any_skip_relocation, ventura:        "97e82d635666e3f778dd12285f8881701110370eaefe6c22fb902b493ae2ba58"
    sha256 cellar: :any_skip_relocation, monterey:       "97e82d635666e3f778dd12285f8881701110370eaefe6c22fb902b493ae2ba58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ca11835e27a0ab600dc0ce1c92b06791fb15b3f7c75d71d97ca4984983deff8"
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

    (testpath/"gulpfile.js").write <<~EOS
      function defaultTask(cb) {
        cb();
      }
      exports.default = defaultTask
    EOS
    assert_match "Finished 'default' after ", shell_output("#{bin}/gulp")
  end
end
