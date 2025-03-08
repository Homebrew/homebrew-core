class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-19.2.1.tgz"
  sha256 "6a18d3d08b624393bb7d1d2912c0c99c40dc87e59107b75ccc345e4e0f2fe2b0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be92ae938d4bebc3d9fc196381780e15d7668acbc529d2f00262efb2f433b9d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be92ae938d4bebc3d9fc196381780e15d7668acbc529d2f00262efb2f433b9d9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "be92ae938d4bebc3d9fc196381780e15d7668acbc529d2f00262efb2f433b9d9"
    sha256 cellar: :any_skip_relocation, sonoma:        "c2f09feddfb9382650b9ac5e4d8f7618402f8e010ad4ad44fec5531da4c2ae2f"
    sha256 cellar: :any_skip_relocation, ventura:       "c2f09feddfb9382650b9ac5e4d8f7618402f8e010ad4ad44fec5531da4c2ae2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be92ae938d4bebc3d9fc196381780e15d7668acbc529d2f00262efb2f433b9d9"
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
