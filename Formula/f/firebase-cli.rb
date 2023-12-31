require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-13.0.2.tgz"
  sha256 "0eb0c1f29740e8a41059a671e418dee7431be6f83ad51960d3f8aed5e8259bb8"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6654dbc12f594d362af36b771fa2f595c4f9f47ede5a470e6c51c690873e8803"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6654dbc12f594d362af36b771fa2f595c4f9f47ede5a470e6c51c690873e8803"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6654dbc12f594d362af36b771fa2f595c4f9f47ede5a470e6c51c690873e8803"
    sha256 cellar: :any_skip_relocation, sonoma:         "a58c2c9370d3cab2f9ed2c94427a6c7dbde47666df710d9566a297ea48a9a7f1"
    sha256 cellar: :any_skip_relocation, ventura:        "a58c2c9370d3cab2f9ed2c94427a6c7dbde47666df710d9566a297ea48a9a7f1"
    sha256 cellar: :any_skip_relocation, monterey:       "a58c2c9370d3cab2f9ed2c94427a6c7dbde47666df710d9566a297ea48a9a7f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7539dcaf9b7db9cc76a05e6980ea9f056b2a1645affd911849d64baa6c15559e"
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
