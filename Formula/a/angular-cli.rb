class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli"
  url "https://registry.npmjs.org/@angular/cli/-/cli-18.2.0.tgz"
  sha256 "3952b000aa4b3ff92e5c2b81205b6e5e67a2b7f994f53b5bfe41c7007deaea39"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6e425f277818e2a5e326ea11adb85a7718040940aaf61b2235593bd579badb86"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6e425f277818e2a5e326ea11adb85a7718040940aaf61b2235593bd579badb86"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e425f277818e2a5e326ea11adb85a7718040940aaf61b2235593bd579badb86"
    sha256 cellar: :any_skip_relocation, sonoma:         "e02a98787398ea0d7f13214f5be0837fbfb966675e184b37fb820f4f3a494a2f"
    sha256 cellar: :any_skip_relocation, ventura:        "e02a98787398ea0d7f13214f5be0837fbfb966675e184b37fb820f4f3a494a2f"
    sha256 cellar: :any_skip_relocation, monterey:       "e02a98787398ea0d7f13214f5be0837fbfb966675e184b37fb820f4f3a494a2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e425f277818e2a5e326ea11adb85a7718040940aaf61b2235593bd579badb86"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"ng", "new", "angular-homebrew-test", "--skip-install"
    assert_predicate testpath/"angular-homebrew-test/package.json", :exist?, "Project was not created"
  end
end
