require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-3.29.12.tgz"
  sha256 "0bdb56e035416e1a337ad1010ea5dc443168b44832381c25116b636039d884f6"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fe2d6cfc51fdc341afd74297a96995f0724f92fc8258dc35768b5a1bb4d281ed"
    sha256 cellar: :any_skip_relocation, big_sur:       "4d03a791d51da2c4e3439a2b23f920c7f295cb56acfe917f083edddfb7a235e6"
    sha256 cellar: :any_skip_relocation, catalina:      "4d03a791d51da2c4e3439a2b23f920c7f295cb56acfe917f083edddfb7a235e6"
    sha256 cellar: :any_skip_relocation, mojave:        "4d03a791d51da2c4e3439a2b23f920c7f295cb56acfe917f083edddfb7a235e6"
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
