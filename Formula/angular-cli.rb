require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-6.0.8.tgz"
  sha256 "0a9fe414eb3188074ffcc52c2a1380e6c26fe45711363f8c4bf0b25bf89e94c8"

  bottle do
    sha256 "0af734601711c9771cf7f6338a8c2d479eb28c8c2a09d7c9bd86a41108b3380e" => :high_sierra
    sha256 "a006358530c0d103f73f16a12b4566f800dcc86fa9832167cefb4aaf9cf75537" => :sierra
    sha256 "a267399ef0c5ce469ed3707722c8ef5ace2d68378fff799018791076c9fd04bf" => :el_capitan
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"ng", "new", "angular-homebrew-test", "--skip-install"
    assert_predicate testpath/"angular-homebrew-test/package.json", :exist?, "Project was not created"
  end
end
