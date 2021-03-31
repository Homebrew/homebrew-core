require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-3.13.10.tgz"
  sha256 "9d15764c603582d0795395889ea256fd67e6c710b1a0e1a9327a73613f056352"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ff7a556908720a828a3ab63364e7979ce234d9e9a16d6b1280fab507563413b9"
    sha256 cellar: :any_skip_relocation, big_sur:       "9a120cbbfea19704903b0fd261807e9af3c47eee409d80c1f5e30d70fd3f6b9f"
    sha256 cellar: :any_skip_relocation, catalina:      "636fd19a65102a4d02dbc158260f54344c35b4386fe1c5fe71831ac1fbe3d17f"
    sha256 cellar: :any_skip_relocation, mojave:        "2e12de412c7ff92f16e81f8b2ab112a3ef159dceb482315b59b249e60f00323d"
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
