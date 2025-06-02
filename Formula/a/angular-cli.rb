class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-20.0.0.tgz"
  sha256 "1603383aac6bc436f506a75827e47cd11d4044b20f6fb1a3288d05dbfb43e704"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6acd941097d79f33fdee807ab9c9f957bf10d91031b703ae93a038d20c4f6766"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6acd941097d79f33fdee807ab9c9f957bf10d91031b703ae93a038d20c4f6766"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6acd941097d79f33fdee807ab9c9f957bf10d91031b703ae93a038d20c4f6766"
    sha256 cellar: :any_skip_relocation, sonoma:        "88e24375d75f3ea2f97a66a1ad391e0c8d12c308a090a5829ec1928496a0d2f0"
    sha256 cellar: :any_skip_relocation, ventura:       "88e24375d75f3ea2f97a66a1ad391e0c8d12c308a090a5829ec1928496a0d2f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6acd941097d79f33fdee807ab9c9f957bf10d91031b703ae93a038d20c4f6766"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6acd941097d79f33fdee807ab9c9f957bf10d91031b703ae93a038d20c4f6766"
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
