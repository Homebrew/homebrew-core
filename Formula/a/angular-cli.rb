require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-17.3.0.tgz"
  sha256 "c6b916439d28d1ed3b02729ea5b28e92d0f2df0254a3f5d6c372a53570abfee0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d5fad58040eb261f3e88453476752bdf667725c80c78f421a69649a53561cc03"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d5fad58040eb261f3e88453476752bdf667725c80c78f421a69649a53561cc03"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d5fad58040eb261f3e88453476752bdf667725c80c78f421a69649a53561cc03"
    sha256 cellar: :any_skip_relocation, sonoma:         "f386f3e179221a6d72b3b12fd9b9e2408e2cff872b99aa566fcdda83042da201"
    sha256 cellar: :any_skip_relocation, ventura:        "f386f3e179221a6d72b3b12fd9b9e2408e2cff872b99aa566fcdda83042da201"
    sha256 cellar: :any_skip_relocation, monterey:       "f386f3e179221a6d72b3b12fd9b9e2408e2cff872b99aa566fcdda83042da201"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5fad58040eb261f3e88453476752bdf667725c80c78f421a69649a53561cc03"
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
