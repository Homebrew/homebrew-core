require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-12.4.8.tgz"
  sha256 "af13e027a7cf2112842ded3b9d80b41ea71e5292da2748d697f117f839c79c97"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8cfd2f688d2865872f87411359c6dff5018c96bb5b7c9e2d8fa3ff90f4f62c42"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8cfd2f688d2865872f87411359c6dff5018c96bb5b7c9e2d8fa3ff90f4f62c42"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8cfd2f688d2865872f87411359c6dff5018c96bb5b7c9e2d8fa3ff90f4f62c42"
    sha256 cellar: :any_skip_relocation, ventura:        "495aab09614985f333bed4cf1140c2d8332b2d2cf99fa579b267e844242b207b"
    sha256 cellar: :any_skip_relocation, monterey:       "495aab09614985f333bed4cf1140c2d8332b2d2cf99fa579b267e844242b207b"
    sha256 cellar: :any_skip_relocation, big_sur:        "495aab09614985f333bed4cf1140c2d8332b2d2cf99fa579b267e844242b207b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0cc10e887c29c4b60604f5e9241fa32829a295dc984f5e97ca136285b425bdf3"
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
