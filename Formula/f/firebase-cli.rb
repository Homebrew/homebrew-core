require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-13.5.2.tgz"
  sha256 "c1bdac1f5d7ae50f355cd97d57b66466bfcaf4c8f6a73be6545e724e9a2e72d6"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "db72b9c22655fd7c66b18aa358b4c1904b1e4cf3e858b1bdb594d2076f11ae8a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "db72b9c22655fd7c66b18aa358b4c1904b1e4cf3e858b1bdb594d2076f11ae8a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "db72b9c22655fd7c66b18aa358b4c1904b1e4cf3e858b1bdb594d2076f11ae8a"
    sha256 cellar: :any_skip_relocation, sonoma:         "02c6ceebe91d5bba7562d07445017e4b2c95b27c4c5de407f2141f5ca890035f"
    sha256 cellar: :any_skip_relocation, ventura:        "02c6ceebe91d5bba7562d07445017e4b2c95b27c4c5de407f2141f5ca890035f"
    sha256 cellar: :any_skip_relocation, monterey:       "02c6ceebe91d5bba7562d07445017e4b2c95b27c4c5de407f2141f5ca890035f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "faf4a7c5f10b85649dab40c5d57ab54b31561b7ed65242ea8f61091545669cdb"
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
