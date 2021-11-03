require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-6.14.10.tgz"
  sha256 "f0292c9e8fb4eaa71d55aa700b9fd06d485c3ac123a6d014fea630a44cbded35"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aca05051e91f3e560da103b31cf0a11caabf7e089da230769fe9d69e149875ce"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "383844160c58f81025c291959da4b6d216e7c672f5058c2bc043bd5ee4b6acd5"
    sha256 cellar: :any_skip_relocation, monterey:       "3327d01a2c0e55d7e500ca62e5eeb0a576cb43efe0875575a3ba4a1ea792e0b3"
    sha256 cellar: :any_skip_relocation, big_sur:        "288b25be9f7a9c094b13a0b0a6669e926e18ec71cafb48f820297b38e2a80792"
    sha256 cellar: :any_skip_relocation, catalina:       "dcedffdab8637a04f51d979c35447513bfa0a841ac1b1a11ea3fd5b59209e24e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "712bf9967988fc2785b414e3bb958fc8e2e24b842634878118bd381b9ac9af87"
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
