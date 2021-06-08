require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-3.35.9.tgz"
  sha256 "c995b8195ca06c9ffec8087fa4fefb3e19193e05ddd960307ae5a27210e377fb"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "35a017831e6f2cdef875b3f84c10c93e0dab39d195406f909ec646d5645859cc"
    sha256 cellar: :any_skip_relocation, big_sur:       "402605b442b43b463d495b34f325bf11c0e3c4dc63c574d18c9fb0ad77b01304"
    sha256 cellar: :any_skip_relocation, catalina:      "402605b442b43b463d495b34f325bf11c0e3c4dc63c574d18c9fb0ad77b01304"
    sha256 cellar: :any_skip_relocation, mojave:        "402605b442b43b463d495b34f325bf11c0e3c4dc63c574d18c9fb0ad77b01304"
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
