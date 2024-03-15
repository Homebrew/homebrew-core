require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-13.5.1.tgz"
  sha256 "177d95da17867fd2cb5fe2291372789d7b535c47424e724ee40a1d45417eec57"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a8d501bdba480b691e2a26e23d36ebee317c241044c3638575340df50a8188e1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a8d501bdba480b691e2a26e23d36ebee317c241044c3638575340df50a8188e1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a8d501bdba480b691e2a26e23d36ebee317c241044c3638575340df50a8188e1"
    sha256 cellar: :any_skip_relocation, sonoma:         "303479301abee3c7eb9bbf3e55049dc0a9b79719115ad3e16c95d3fc66d552a3"
    sha256 cellar: :any_skip_relocation, ventura:        "303479301abee3c7eb9bbf3e55049dc0a9b79719115ad3e16c95d3fc66d552a3"
    sha256 cellar: :any_skip_relocation, monterey:       "303479301abee3c7eb9bbf3e55049dc0a9b79719115ad3e16c95d3fc66d552a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c847e296b09dd19ed0a45f4b86956547367d0b13c3e4cb1931ac3c656ffd5195"
  end

  depends_on "node"

  uses_from_macos "expect" => :test

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.exp").write <<~EOS
      spawn #{bin}/firebase login:ci --no-localhost
      expect "Paste"
    EOS
    assert_match "authorization code", shell_output("expect -f test.exp")
  end
end
