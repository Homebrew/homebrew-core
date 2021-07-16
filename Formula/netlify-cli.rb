require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-4.4.0.tgz"
  sha256 "817283a7be1b45d67d7eeb3b5d69b13450e33bb3de3c9f1d141803299ccd7767"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2b521ec28adc84c35ef66cfa2adeb2780a9eaaa01da8ba36ce4b214faeacabca"
    sha256 cellar: :any_skip_relocation, big_sur:       "dda69c7c42122d0fba5ab99454aa81fc7d4943f5406408e63876d415d0aed276"
    sha256 cellar: :any_skip_relocation, catalina:      "dda69c7c42122d0fba5ab99454aa81fc7d4943f5406408e63876d415d0aed276"
    sha256 cellar: :any_skip_relocation, mojave:        "dda69c7c42122d0fba5ab99454aa81fc7d4943f5406408e63876d415d0aed276"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "581b48cde745b6abfd219db176eba9242d52103c85a66fbaa5b7b3bd808278b2"
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
