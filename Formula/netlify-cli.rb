require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-6.7.5.tgz"
  sha256 "62c6e1f7e0f543a92ec188ba9188e8f1ea2737581ee4b0a24cbc257092ceda94"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c2dcecb19d1906f50bb4ca832d9a96613f335d9a1b8cade79da8226fb55a616e"
    sha256 cellar: :any_skip_relocation, big_sur:       "16550c0232f14a9023db9157f810912c29c8e8404869ca7006f9154140ad0183"
    sha256 cellar: :any_skip_relocation, catalina:      "16550c0232f14a9023db9157f810912c29c8e8404869ca7006f9154140ad0183"
    sha256 cellar: :any_skip_relocation, mojave:        "16550c0232f14a9023db9157f810912c29c8e8404869ca7006f9154140ad0183"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7899fd183cdf802b9f64da76865beeb62e2820d28ca9228131f274f92dc13307"
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
