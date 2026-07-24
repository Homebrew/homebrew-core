class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-22.0.8.tgz"
  sha256 "7f815d66cdd908049c8989ac79e54dd63a7089b38bbce32e706a16524f094807"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2e844206fd4d9c87dfe99797fa5011919c23fe757c0d41e6fa8ea65ae519baa7"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"ng", "new", "angular-homebrew-test", "--skip-install"
    assert_path_exists testpath/"angular-homebrew-test/package.json", "Project was not created"
  end
end
