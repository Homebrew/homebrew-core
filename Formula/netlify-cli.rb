require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-6.5.0.tgz"
  sha256 "f191d0224b5e50a8a63ef75c171131a1f26369c0b38827e5b32803f400f4d590"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8d944f2da6878e48341f2e52a98ac4d7569934d8e00113473eaabb878cc14b3a"
    sha256 cellar: :any_skip_relocation, big_sur:       "aacc0f440ad646ef47d4ee2a554cd6a42e004cf2013324ea69cbd64b2c6e5875"
    sha256 cellar: :any_skip_relocation, catalina:      "aacc0f440ad646ef47d4ee2a554cd6a42e004cf2013324ea69cbd64b2c6e5875"
    sha256 cellar: :any_skip_relocation, mojave:        "aacc0f440ad646ef47d4ee2a554cd6a42e004cf2013324ea69cbd64b2c6e5875"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c1218ca403537a64ab40e0ad3439b617f7d126bd428b247028819eb07e6899c"
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
