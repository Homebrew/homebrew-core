require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-7.1.1.tgz"
  sha256 "e0a68755d78d2584477b2852ec7f42f4a5554746a873bd5bc7f1ae59e3e762c3"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    sha256 "080c277b5bdefadf4f3470ea27359175f5af75f63dc0d4e90ee9bcd2e0423e4f" => :mojave
    sha256 "4846b1e1d27b758692cd70f302bcd10fd8c4db15abc391250470aa2be1e079f8" => :high_sierra
    sha256 "faaafd114910418c09c9ea26d9d21cca44d7f7cf5523bf20013f140f27fda819" => :sierra
  end

  depends_on "node"

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
