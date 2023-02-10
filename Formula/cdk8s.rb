require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.132.tgz"
  sha256 "1398f1f8906307af0b6f775e29858240acfd788e49e24a915ec93c218662c97c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d581ee0f206c7802d56b717dfa520a50052cc4a8068a9943495d61f8eda36501"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa3b2fcf8b455a9a46e3494562e64899d1a085efe08f8ec2907172d4267dc839"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bf6e147f24e21a8a51d726514fd632bffedba25cdcd7655c3058cc9f2bc65ded"
    sha256 cellar: :any_skip_relocation, ventura:        "e11db410d603ca166cbd9efa96e0bd37a307512394a30db1882b9fb4c6439943"
    sha256 cellar: :any_skip_relocation, monterey:       "8144f00ab6850f79c2755843b032d96fa16d125962f0250ab609e3ab90f18488"
    sha256 cellar: :any_skip_relocation, big_sur:        "04d40ca9fa5fdebf6b12acb5cd38fc02ae229afeca4bedfc40af48979f137ea9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08a9077230979ef63a6f6ca1d72bd744c7955521ecef21119eae356524a55ca0"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Cannot initialize a project in a non-empty directory",
      shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
  end
end
