require "language/node"

class GulpCli < Formula
  desc "Command-line utility for Gulp"
  homepage "https://github.com/gulpjs/gulp-cli"
  url "https://registry.npmjs.org/gulp-cli/-/gulp-cli-3.0.0.tgz"
  sha256 "f90ba044fd1486dcc0f5e7ec07aba39fc62079cd0f3df78f2ba123b404f8094b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f07bd7a6d69f5b7e2476bcd3ea6ad2346d131c435267d551a6c2dd66ecf4369f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f07bd7a6d69f5b7e2476bcd3ea6ad2346d131c435267d551a6c2dd66ecf4369f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f07bd7a6d69f5b7e2476bcd3ea6ad2346d131c435267d551a6c2dd66ecf4369f"
    sha256 cellar: :any_skip_relocation, sonoma:         "3e874ad640e88888810e0b31f362efca2a993c5312f292cb82b172e0633bc662"
    sha256 cellar: :any_skip_relocation, ventura:        "3e874ad640e88888810e0b31f362efca2a993c5312f292cb82b172e0633bc662"
    sha256 cellar: :any_skip_relocation, monterey:       "3e874ad640e88888810e0b31f362efca2a993c5312f292cb82b172e0633bc662"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f07bd7a6d69f5b7e2476bcd3ea6ad2346d131c435267d551a6c2dd66ecf4369f"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "npm", "init", "-y"
    system "npm", "install", *Language::Node.local_npm_install_args, "gulp"

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
