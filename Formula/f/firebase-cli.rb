require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-12.5.2.tgz"
  sha256 "cd6a995b2de054e04694405ca5b59ff5047c44d30d131145cef205dad5dd536a"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "712bfcd9042993ee7d1b79e4cd403d0cd02a656e041338f148adb01bf1c95d0a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "712bfcd9042993ee7d1b79e4cd403d0cd02a656e041338f148adb01bf1c95d0a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "712bfcd9042993ee7d1b79e4cd403d0cd02a656e041338f148adb01bf1c95d0a"
    sha256 cellar: :any_skip_relocation, ventura:        "9c5430a6b389086ab1038b1560deed9ccdc3ea08b24d0c307af995762fc32e6d"
    sha256 cellar: :any_skip_relocation, monterey:       "9c5430a6b389086ab1038b1560deed9ccdc3ea08b24d0c307af995762fc32e6d"
    sha256 cellar: :any_skip_relocation, big_sur:        "9c5430a6b389086ab1038b1560deed9ccdc3ea08b24d0c307af995762fc32e6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90d9a42fc6112517030a11b83ab8d1acdd864e39cc8b50a19450cc086eee2755"
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
