require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-12.7.0.tgz"
  sha256 "0a277614d71c9a8b15447ffe8ba04d541ce9d4bf9b902d937399715134e9985c"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aca1e2ee18b97a11db5a19e419fddb1a8bf421c93899be9caaafc6838566d1fb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aca1e2ee18b97a11db5a19e419fddb1a8bf421c93899be9caaafc6838566d1fb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aca1e2ee18b97a11db5a19e419fddb1a8bf421c93899be9caaafc6838566d1fb"
    sha256 cellar: :any_skip_relocation, sonoma:         "92d72a9aa5c5d0a51bc55a6c888af2b871f185d9131e0030a5e051295d6800f6"
    sha256 cellar: :any_skip_relocation, ventura:        "92d72a9aa5c5d0a51bc55a6c888af2b871f185d9131e0030a5e051295d6800f6"
    sha256 cellar: :any_skip_relocation, monterey:       "92d72a9aa5c5d0a51bc55a6c888af2b871f185d9131e0030a5e051295d6800f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59856adc1d479e530ace3d26e0abb92f723e5a3b869e07fbdcc774e31c7c9751"
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
