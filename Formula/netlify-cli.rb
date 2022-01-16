require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-8.8.0.tgz"
  sha256 "ac5dcac3c134ad2b5c3a3e2e0134535a7d074b580e9b74cc3749ea698258e6e2"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e365d7d48b82fd9bb7871ae30b977702c66c53c8c9bc711455abba8dca52b1b2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e365d7d48b82fd9bb7871ae30b977702c66c53c8c9bc711455abba8dca52b1b2"
    sha256 cellar: :any_skip_relocation, monterey:       "221b31ce8805f97efe80e8e42da47e1f8a470baefee7991ad356addb42652f0e"
    sha256 cellar: :any_skip_relocation, big_sur:        "221b31ce8805f97efe80e8e42da47e1f8a470baefee7991ad356addb42652f0e"
    sha256 cellar: :any_skip_relocation, catalina:       "221b31ce8805f97efe80e8e42da47e1f8a470baefee7991ad356addb42652f0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef5a26a7e0951bc9e711020215c4171e8db39d6d70ceec60ca3d54fc5fbc45f0"
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
