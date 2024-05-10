require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-13.8.2.tgz"
  sha256 "8558322c4bb8c1e8636d765271ee3f7cfb4e22543d652fb8222f8f24251e25fb"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "145a675dfb64bede588f12b2e32830477b1610f5ca1e2fccc1f4fde8afde8a6c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "93b12d25ca70f7b17cf8de3c782bd02821b5b2a8fa1b4040d1be8b679a81fd5c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "18a7fadde70071a19c2c5af87ea82c78344be2d67bb80dd618ae30f14f8c3351"
    sha256                               sonoma:         "b681358202eda084b986f8d709badbd9f2887dea85738028d8cf6ac9dacd79a6"
    sha256                               ventura:        "20522ce4223ed8be7dc774f43d2d811fba22c27807a737925bd31c2477d7dd6e"
    sha256                               monterey:       "331e14a092ac5250003a4fd2b78df78c2f2d2bd8743137ecc25e7893afb464b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "158a23a85b226f6c9234dd783e9cb150151d822088f7129e14e417cc5ff33e79"
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
