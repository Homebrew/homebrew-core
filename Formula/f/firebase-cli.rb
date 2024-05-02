require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-13.8.0.tgz"
  sha256 "259bf8e62bbf2a7b7ec4f991712f9449636b644d6ba58fbbc448f54757951116"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_sonoma:   "700b32d78a49fb70d6eb427c14a3bd4092dfe00994c2819023237a6162952664"
    sha256                               arm64_ventura:  "2e5b864fc5873fff7bc08e8db618bde09609aa98146798e35d1cd84a93250bcb"
    sha256                               arm64_monterey: "921cb51b9b15cf1b184b533118fac3e537095d7b7bdc606c986875d0d6c42f2e"
    sha256                               sonoma:         "421cd86ee6971d086e38442e4e9707263f4d93088e533ae970de2b2c4edcc2cc"
    sha256                               ventura:        "f6fe07a67b6ec9ea60f2dca14e193556bdcaf33cc06725b54f20ca802b9bee12"
    sha256                               monterey:       "cd1e8bb5cfa1bb878b9b4e68ade7095c3d2a8fbbd7ef835d93a06576b1ff2812"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56268aa8b58264e6d974f4a407343fe7846a7416ed8f1a98e1d1527db0725d30"
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
