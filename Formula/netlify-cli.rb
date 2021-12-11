require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-8.0.20.tgz"
  sha256 "ce617de0f363c21ec447a365b0c12225db3812ac5fb0efba805cbdd0bb6a50b3"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd0175e9b81f6c7076e8504e9df69ad74be8b7b0e869e1f042599e1498ddac32"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cd0175e9b81f6c7076e8504e9df69ad74be8b7b0e869e1f042599e1498ddac32"
    sha256 cellar: :any_skip_relocation, monterey:       "659a432c2404f61202e6fcea23e33755bc21f06f0916547d91bb2781998f1251"
    sha256 cellar: :any_skip_relocation, big_sur:        "659a432c2404f61202e6fcea23e33755bc21f06f0916547d91bb2781998f1251"
    sha256 cellar: :any_skip_relocation, catalina:       "659a432c2404f61202e6fcea23e33755bc21f06f0916547d91bb2781998f1251"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dcac45cf913c02796c3dea6dcd5f470ede436203624a00beac7794a7a5b96444"
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
