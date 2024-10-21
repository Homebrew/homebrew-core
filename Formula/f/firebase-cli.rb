class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-13.22.1.tgz"
  sha256 "e0ec0dc4ff4db026ad3e21f7f0163f188612675399633a0bfa6540334872bb8a"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27871d2f7bc6ff5d7b2ae0ee76ca99d81c10f8170fab92e939e0e4aebd37a96d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "27871d2f7bc6ff5d7b2ae0ee76ca99d81c10f8170fab92e939e0e4aebd37a96d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "27871d2f7bc6ff5d7b2ae0ee76ca99d81c10f8170fab92e939e0e4aebd37a96d"
    sha256 cellar: :any_skip_relocation, sonoma:        "427cb68226c763e2f8de38dd1adf29f340d4b4fff1452b8376a4b61d79b47026"
    sha256 cellar: :any_skip_relocation, ventura:       "427cb68226c763e2f8de38dd1adf29f340d4b4fff1452b8376a4b61d79b47026"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cf320d687a4414d2cd85f2fb33f9717758403706f75cd3f55d0e07a234b05cc8"
  end

  depends_on "node"

  uses_from_macos "expect" => :test

  def install
    system "npm", "install", *std_npm_args
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
