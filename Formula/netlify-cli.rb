require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-7.0.0.tgz"
  sha256 "cafcd7977d30f8a2772b6f70d340786e6c427f837c99f8ba8c6af0d6e4380fe4"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3965de33b2d9175a6faed536d29f1cdd1da8798de7eb75a5f368cea461bf79e3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3965de33b2d9175a6faed536d29f1cdd1da8798de7eb75a5f368cea461bf79e3"
    sha256 cellar: :any_skip_relocation, monterey:       "089e8f0797f422101221f0ca58c7a1edaed66965affb8991488d1dfe1beb0310"
    sha256 cellar: :any_skip_relocation, big_sur:        "089e8f0797f422101221f0ca58c7a1edaed66965affb8991488d1dfe1beb0310"
    sha256 cellar: :any_skip_relocation, catalina:       "089e8f0797f422101221f0ca58c7a1edaed66965affb8991488d1dfe1beb0310"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7555f1281e40c11947958ac508414ebce06a594b30b5030771472382b3160af"
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
