require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-9.3.0.tgz"
  sha256 "635f88d3320a3fbf53f3d1e6c5b8a6eae9a4f927926ffba41c6bf738e8c25681"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    sha256                               arm64_big_sur: "164272fc6509d724c6fcc877ee988b6b6a3c9e1ab572fab6e93cf91fed432042"
    sha256 cellar: :any_skip_relocation, big_sur:       "8720c16da6eaadeb2e8155adfa302b7621137e8cc74344344dab680f4d9d6266"
    sha256 cellar: :any_skip_relocation, catalina:      "a665da560eb8a7dfa18b563e3991de9b0a24bc8f2e5f24d02106ae5e4a0a86ba"
    sha256 cellar: :any_skip_relocation, mojave:        "b3a2587705ce4863ec6f1fdcdc2857d7017f4b913c30840f36b8161ccc2a8900"
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
