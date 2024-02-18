require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-13.3.0.tgz"
  sha256 "75815c592daa14d50d3101573594ef76bf3b5bbe840559692d1b9c666935a667"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f7576f0df93cd3a668309e561530829919460deead8abf27cb3c08121f9dd466"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f7576f0df93cd3a668309e561530829919460deead8abf27cb3c08121f9dd466"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f7576f0df93cd3a668309e561530829919460deead8abf27cb3c08121f9dd466"
    sha256 cellar: :any_skip_relocation, sonoma:         "a87810808a81ccd15f29b0c47f2a951ddc34e6bdc0ea183baf94db85fc1a1df4"
    sha256 cellar: :any_skip_relocation, ventura:        "a87810808a81ccd15f29b0c47f2a951ddc34e6bdc0ea183baf94db85fc1a1df4"
    sha256 cellar: :any_skip_relocation, monterey:       "a87810808a81ccd15f29b0c47f2a951ddc34e6bdc0ea183baf94db85fc1a1df4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "40b721d53ca5b08c351eb49e5dde98d968d5abb9464d03d49409df7d4503e0bc"
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
