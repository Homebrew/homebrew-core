require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-9.13.1.tgz"
  sha256 "7d78e97a78de80cb6eb275b8b4cf97cfb1c2df802f3209497a8d448343418c74"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git"

  bottle do
    sha256                               arm64_big_sur: "d056efd3744b3bee144da521cf62cda0564d3b3051c76315a17fa6b68a6b4c23"
    sha256 cellar: :any_skip_relocation, big_sur:       "b455bc9e40dc9c90ca568e06af3589457ca864bb6bd46b96c8a8a76722d99a81"
    sha256 cellar: :any_skip_relocation, catalina:      "b455bc9e40dc9c90ca568e06af3589457ca864bb6bd46b96c8a8a76722d99a81"
    sha256 cellar: :any_skip_relocation, mojave:        "b455bc9e40dc9c90ca568e06af3589457ca864bb6bd46b96c8a8a76722d99a81"
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
