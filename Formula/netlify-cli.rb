require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-6.13.0.tgz"
  sha256 "2db2f9457710fe0c1efece029621c0e93301d3e6b24ab22d55abedcb02370f7e"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b91a1819a29406228b41fae41d8fde4beadac94cda2644963bed282502503634"
    sha256 cellar: :any_skip_relocation, big_sur:       "b0ef6f00e8d656b6652be55f9803f9376f742287f505567243799a2e4cac1cd2"
    sha256 cellar: :any_skip_relocation, catalina:      "b0ef6f00e8d656b6652be55f9803f9376f742287f505567243799a2e4cac1cd2"
    sha256 cellar: :any_skip_relocation, mojave:        "b0ef6f00e8d656b6652be55f9803f9376f742287f505567243799a2e4cac1cd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02e173f6c715f13ae6511623cf5a44e8ca0b41599500bbc52864190081b93e06"
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
