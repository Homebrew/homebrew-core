class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.198.193.tgz"
  sha256 "375fc91e70809894a6e2c7d17d97d4567c631d08dfe9a172a598f6b37d23cf6b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d4cae19c25362050a0e2f962824a3a24bdb1dd5f2ad32aa2de87577ac93ef6d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d4cae19c25362050a0e2f962824a3a24bdb1dd5f2ad32aa2de87577ac93ef6d8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d4cae19c25362050a0e2f962824a3a24bdb1dd5f2ad32aa2de87577ac93ef6d8"
    sha256 cellar: :any_skip_relocation, sonoma:         "2bef257ecc8eae35c97b50916f18b49021c01532d2e503ea6de0f0d805952148"
    sha256 cellar: :any_skip_relocation, ventura:        "2bef257ecc8eae35c97b50916f18b49021c01532d2e503ea6de0f0d805952148"
    sha256 cellar: :any_skip_relocation, monterey:       "2bef257ecc8eae35c97b50916f18b49021c01532d2e503ea6de0f0d805952148"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4cae19c25362050a0e2f962824a3a24bdb1dd5f2ad32aa2de87577ac93ef6d8"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
    assert_match "Initializing a project from the python-app template", output
  end
end
