require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-4.3.0.tgz"
  sha256 "5fed30172c743db16bea25107e075228a689b503369dcb7d48b86bdd6d5f1f63"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2f8af20be6345ba4c74bf2ae74b9f1ecf385ea6489b2d75e0ea2aa9940bb36d0"
    sha256 cellar: :any_skip_relocation, big_sur:       "f6a3ba9331996bbbe4c2d9475a855fb57daf72cf80655bdd80bebaba5b62d294"
    sha256 cellar: :any_skip_relocation, catalina:      "f6a3ba9331996bbbe4c2d9475a855fb57daf72cf80655bdd80bebaba5b62d294"
    sha256 cellar: :any_skip_relocation, mojave:        "f6a3ba9331996bbbe4c2d9475a855fb57daf72cf80655bdd80bebaba5b62d294"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17fb70f0075ba14142a0d21a53fbdb019b709fe58cee14b3fe7525ea5bca8c86"
  end

  depends_on "node"

  uses_from_macos "expect" => :test

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.exp").write <<~EOS
      spawn #{bin}/netlify login
      expect "Opening"
    EOS
    assert_match "Logging in", shell_output("expect -f test.exp")
  end
end
