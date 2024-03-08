require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-13.4.1.tgz"
  sha256 "12c4590d18f080a9c01463978d0c351355aa5c160628e392a229c36058d9ee0a"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6aa0cdcc3f29eb10fc5315331820306ed7a57d82c89812b8e53146c97ff2cce0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6aa0cdcc3f29eb10fc5315331820306ed7a57d82c89812b8e53146c97ff2cce0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6aa0cdcc3f29eb10fc5315331820306ed7a57d82c89812b8e53146c97ff2cce0"
    sha256 cellar: :any_skip_relocation, sonoma:         "4405e1bc0bcd64725a3cdf4c8c06f4b1c6822b2c6e060de5321fe65f5725508c"
    sha256 cellar: :any_skip_relocation, ventura:        "4405e1bc0bcd64725a3cdf4c8c06f4b1c6822b2c6e060de5321fe65f5725508c"
    sha256 cellar: :any_skip_relocation, monterey:       "4405e1bc0bcd64725a3cdf4c8c06f4b1c6822b2c6e060de5321fe65f5725508c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81a85f74fd8763c6c58f5cac3f045d69b1e9c70b7f202cd017e76facdeb510dc"
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
