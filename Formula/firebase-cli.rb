require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-11.28.0.tgz"
  sha256 "e49eaa65c5afd77e52180e472214864874c58117b7dfb347e0fcad3feaa75528"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_ventura:  "c67db91cdd9c7bb501aac1eb859b06d9a5a22c314ae217741c1a052806ac3ecb"
    sha256                               arm64_monterey: "93a770d3ffd49e0280d4bcbf10dae030ae96a690e636903f2b7ab549f5f0a127"
    sha256                               arm64_big_sur:  "2d1c56acfca303c0e7c9df9132c939d5ee473984258d32711f99185665c687c9"
    sha256 cellar: :any_skip_relocation, ventura:        "6d94be0906ea6a447d457472a4e7d8ac27e08f83bcaa3ab40c085924efd3dba2"
    sha256 cellar: :any_skip_relocation, monterey:       "6d94be0906ea6a447d457472a4e7d8ac27e08f83bcaa3ab40c085924efd3dba2"
    sha256 cellar: :any_skip_relocation, big_sur:        "6d94be0906ea6a447d457472a4e7d8ac27e08f83bcaa3ab40c085924efd3dba2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7739bbd28c8cb3c17b594d08fb3f9954e30473cf89dc2796750b9cbacfa4ce40"
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
