require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-12.8.0.tgz"
  sha256 "49c1b430048b528f26e8f97d20f05f3bd8eddb777999d001bae3aa91298aa28d"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c75e886aa19c02a9c104bc7bd09defda808cac6e4055f5da3dd0b4ec77c03a3e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c75e886aa19c02a9c104bc7bd09defda808cac6e4055f5da3dd0b4ec77c03a3e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c75e886aa19c02a9c104bc7bd09defda808cac6e4055f5da3dd0b4ec77c03a3e"
    sha256 cellar: :any_skip_relocation, sonoma:         "653194d01a441550d5ae7b9d79b83fcc611032406fbc6693d71b10065e8c19a7"
    sha256 cellar: :any_skip_relocation, ventura:        "653194d01a441550d5ae7b9d79b83fcc611032406fbc6693d71b10065e8c19a7"
    sha256 cellar: :any_skip_relocation, monterey:       "653194d01a441550d5ae7b9d79b83fcc611032406fbc6693d71b10065e8c19a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2da5e26aae77bfafc44791e11afbd0e61379b26419ea0bb2d7c1d118f2632598"
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
