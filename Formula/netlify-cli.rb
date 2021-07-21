require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-5.1.0.tgz"
  sha256 "bf7af06f89515e7849e7e7f15bc94d6a2ce7105804dfd370d416e3d2412b16df"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4ea1eb56648a4f92f3695fcc60c51bb2fcc32c3118df18d5091bedfb3124cd65"
    sha256 cellar: :any_skip_relocation, big_sur:       "1df1662e6b1a9a7011c6b106caa8b57cbe940f08d9cf7bb23740f952256f96c1"
    sha256 cellar: :any_skip_relocation, catalina:      "1df1662e6b1a9a7011c6b106caa8b57cbe940f08d9cf7bb23740f952256f96c1"
    sha256 cellar: :any_skip_relocation, mojave:        "1df1662e6b1a9a7011c6b106caa8b57cbe940f08d9cf7bb23740f952256f96c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6df6323bac5f322305ea269143234f78cd26cbae9d7e96dd12e93bd511c0c676"
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
