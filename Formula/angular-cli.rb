require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-1.6.0.tgz"
  sha256 "aafe0310fe778b32f96e9d64e4c838f84de45ab3de7b61c977d40b4f6f5e7b0f"

  bottle do
    sha256 "2b81bc1d6d403796572ea109ba93a4a6c8f6adf81bf3abf30cf5b84f988f97b5" => :high_sierra
    sha256 "111756ed422cf569ff9a34345577cd1d3e9c46e29d5df25aa2abb04ee018c14d" => :sierra
    sha256 "831ea140d497370f07c09d8d71f28bc60f43e94b8e4d6b2c6a7bfa534cfc7969" => :el_capitan
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"ng", "new", "--skip-install", "angular-homebrew-test"
    assert_predicate testpath/"angular-homebrew-test/package.json", :exist?, "Project was not created"
  end
end
