require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-7.16.1.tgz"
  sha256 "4c974bbc3abcef7947c43fa14a1247941d7d947da51aa8f375cca105c67871c1"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a41e23f29aa7468aa0fe2eaa58023835e68fdc79e5736221fbffc3d3eff2511d" => :catalina
    sha256 "2e1e2ae897b5ece417d4fda2ed555530033224bc01772c338a0cb7f51dd83ae8" => :mojave
    sha256 "30dc3f74fad2269bac734bfe08e6afbc3845efaf1f808cf4cd90ab261f49c770" => :high_sierra
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
