class InstallPeerdeps < Formula
  desc "CLI to automatically install peerDeps"
  homepage "https://github.com/nathanhleung/install-peerdeps"
  url "https://registry.npmjs.org/install-peerdeps/-/install-peerdeps-3.0.3.tgz"
  sha256 "a1f0e865f9db356aa15ccc9cb56e200c442229bef9e1e1ef8c73bcd587dfc506"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e795fe1ad6a1fed06a19636c4d93c4c630ddd71a16016035d29aff99885785a5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e795fe1ad6a1fed06a19636c4d93c4c630ddd71a16016035d29aff99885785a5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e795fe1ad6a1fed06a19636c4d93c4c630ddd71a16016035d29aff99885785a5"
    sha256 cellar: :any_skip_relocation, sonoma:         "e795fe1ad6a1fed06a19636c4d93c4c630ddd71a16016035d29aff99885785a5"
    sha256 cellar: :any_skip_relocation, ventura:        "e795fe1ad6a1fed06a19636c4d93c4c630ddd71a16016035d29aff99885785a5"
    sha256 cellar: :any_skip_relocation, monterey:       "e795fe1ad6a1fed06a19636c4d93c4c630ddd71a16016035d29aff99885785a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b833efc753877c4c00df8f7cff9c6df4291799e3b254eba899cbf5fdee45dd9"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"install-peerdeps", "eslint-config-airbnb@19.0.4"
    assert_predicate testpath/"node_modules"/"eslint", :exist? # eslint is a peerdep
  end
end
