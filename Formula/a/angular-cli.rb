require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-17.2.1.tgz"
  sha256 "4c2afd3d606ba3bd8ebaaece0ae52c94595ad7fcd28fcae48c0a20cf33570f29"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "25a9588a037af3383c38d25302030dbf445126e828288e9bdaaa3bf1f3d1199e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "25a9588a037af3383c38d25302030dbf445126e828288e9bdaaa3bf1f3d1199e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25a9588a037af3383c38d25302030dbf445126e828288e9bdaaa3bf1f3d1199e"
    sha256 cellar: :any_skip_relocation, sonoma:         "922afe4aa05e88b2babf8422b2c4f3e59ad55cb1deef635ac929abae73a2bc09"
    sha256 cellar: :any_skip_relocation, ventura:        "922afe4aa05e88b2babf8422b2c4f3e59ad55cb1deef635ac929abae73a2bc09"
    sha256 cellar: :any_skip_relocation, monterey:       "922afe4aa05e88b2babf8422b2c4f3e59ad55cb1deef635ac929abae73a2bc09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25a9588a037af3383c38d25302030dbf445126e828288e9bdaaa3bf1f3d1199e"
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
