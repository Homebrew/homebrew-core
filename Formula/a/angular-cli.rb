class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-19.2.7.tgz"
  sha256 "e1a778c0ca103532cb897b95bb8208255bca1c8aff18542d7c9b5abd24d364d4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a454db10cc9b5dc1cc8e83ed8e0d04e5dd4777cb35b913051e3460d6bd06ede5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a454db10cc9b5dc1cc8e83ed8e0d04e5dd4777cb35b913051e3460d6bd06ede5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a454db10cc9b5dc1cc8e83ed8e0d04e5dd4777cb35b913051e3460d6bd06ede5"
    sha256 cellar: :any_skip_relocation, sonoma:        "278517279ec7ad120b2c0f586df7d3af3550af0c8a166196a406df9ba32acf92"
    sha256 cellar: :any_skip_relocation, ventura:       "278517279ec7ad120b2c0f586df7d3af3550af0c8a166196a406df9ba32acf92"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a454db10cc9b5dc1cc8e83ed8e0d04e5dd4777cb35b913051e3460d6bd06ede5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a454db10cc9b5dc1cc8e83ed8e0d04e5dd4777cb35b913051e3460d6bd06ede5"
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
