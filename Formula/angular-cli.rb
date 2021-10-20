require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-12.2.10.tgz"
  sha256 "0d00c266d5ba60bd0656ad728187692b8979f26e0c0aaa93691de74530202231"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6a4fe6f04a15a1a0f8347540c9a62cbbe7f94b6d0cc294b7b10f32b11de0696a"
    sha256 cellar: :any_skip_relocation, big_sur:       "8df3a7e7fc6b3ff4d5b626e12da99447a21abf972c0bf64afe1c4c015e256566"
    sha256 cellar: :any_skip_relocation, catalina:      "8df3a7e7fc6b3ff4d5b626e12da99447a21abf972c0bf64afe1c4c015e256566"
    sha256 cellar: :any_skip_relocation, mojave:        "8df3a7e7fc6b3ff4d5b626e12da99447a21abf972c0bf64afe1c4c015e256566"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a4fe6f04a15a1a0f8347540c9a62cbbe7f94b6d0cc294b7b10f32b11de0696a"
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
