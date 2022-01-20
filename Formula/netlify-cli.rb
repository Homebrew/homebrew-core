require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-8.11.0.tgz"
  sha256 "cce6fff227a3812bfd100aaed6b421154b905ce67ef510c7939029fc11d9bd64"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "88789c979ee16245b29a89a065f0a2030f1d96e7023bcf250096a5ea1597e373"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "88789c979ee16245b29a89a065f0a2030f1d96e7023bcf250096a5ea1597e373"
    sha256 cellar: :any_skip_relocation, monterey:       "1e9f9e3761c87640d0fdfc7a8af4f52d0a87fb56a37eae4fa0130e080732d6d4"
    sha256 cellar: :any_skip_relocation, big_sur:        "1e9f9e3761c87640d0fdfc7a8af4f52d0a87fb56a37eae4fa0130e080732d6d4"
    sha256 cellar: :any_skip_relocation, catalina:       "1e9f9e3761c87640d0fdfc7a8af4f52d0a87fb56a37eae4fa0130e080732d6d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c57dfb52a59514a153bbdf1ec40ce224ec237ca26ebf2567d1975f65c05b0116"
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
