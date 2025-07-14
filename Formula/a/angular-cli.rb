class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-20.1.0.tgz"
  sha256 "d966f1f9bb291a6b3476517e63aa7354641d5fcb3998d3c2d9325f4b008f2047"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a1e1bf4c6a0116aae6d5caa58c64988aa768e74fcc5c5982b5a2005fb84abecf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a1e1bf4c6a0116aae6d5caa58c64988aa768e74fcc5c5982b5a2005fb84abecf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a1e1bf4c6a0116aae6d5caa58c64988aa768e74fcc5c5982b5a2005fb84abecf"
    sha256 cellar: :any_skip_relocation, sonoma:        "8988a3fc7545d1837011473058a2a059ecd1811b3c9cd8dc7b55e9d2c6f717d7"
    sha256 cellar: :any_skip_relocation, ventura:       "8988a3fc7545d1837011473058a2a059ecd1811b3c9cd8dc7b55e9d2c6f717d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a1e1bf4c6a0116aae6d5caa58c64988aa768e74fcc5c5982b5a2005fb84abecf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1e1bf4c6a0116aae6d5caa58c64988aa768e74fcc5c5982b5a2005fb84abecf"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"ng", "new", "angular-homebrew-test", "--skip-install"
    assert_path_exists testpath/"angular-homebrew-test/package.json", "Project was not created"
  end
end
