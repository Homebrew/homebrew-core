require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-9.2.0.tgz"
  sha256 "5451b3336add2446bef5f4d491750233b6841cb1113c13bcb2414a5ad3872fc1"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6be56d2ba22f38c9ddb74de895f0ca78cdd23b540782034f5b8541f69bd9d58b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6be56d2ba22f38c9ddb74de895f0ca78cdd23b540782034f5b8541f69bd9d58b"
    sha256 cellar: :any_skip_relocation, monterey:       "bd5a344d71dc1a3acde1125cdce1a5aa3dcd6867a82b68c8dbede797be4636d5"
    sha256 cellar: :any_skip_relocation, big_sur:        "bd5a344d71dc1a3acde1125cdce1a5aa3dcd6867a82b68c8dbede797be4636d5"
    sha256 cellar: :any_skip_relocation, catalina:       "bd5a344d71dc1a3acde1125cdce1a5aa3dcd6867a82b68c8dbede797be4636d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d30a59a6b426aae17f593a208e3c7216ed9785974211546161271b62629fccdc"
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
