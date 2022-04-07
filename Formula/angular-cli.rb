require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-13.3.2.tgz"
  sha256 "b42b23d41b5ae2c36b21f091d1473546d538a7cbe26cd1a456b415e20cc51eb8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "921c8f8c47b0844e373b738e7e1e2af71641136b271f94e48ac94bd34938971c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "921c8f8c47b0844e373b738e7e1e2af71641136b271f94e48ac94bd34938971c"
    sha256 cellar: :any_skip_relocation, monterey:       "5e0f266b519b9561c2bc0dd8407bbce95743c1c197e13834f913f06872127ad6"
    sha256 cellar: :any_skip_relocation, big_sur:        "5e0f266b519b9561c2bc0dd8407bbce95743c1c197e13834f913f06872127ad6"
    sha256 cellar: :any_skip_relocation, catalina:       "5e0f266b519b9561c2bc0dd8407bbce95743c1c197e13834f913f06872127ad6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "921c8f8c47b0844e373b738e7e1e2af71641136b271f94e48ac94bd34938971c"
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
