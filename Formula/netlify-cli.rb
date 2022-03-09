require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-9.13.0.tgz"
  sha256 "f81c7d48a24c7f18bc0f012f7dca6e790a4c25e544f8a542ac7697f9ed755b65"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d196a8f72a9699b0796d7f6a4d62f24084299c6abfa79d7d502153069a46ba8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6d196a8f72a9699b0796d7f6a4d62f24084299c6abfa79d7d502153069a46ba8"
    sha256 cellar: :any_skip_relocation, monterey:       "da3e3a3799fb9f3a9a7a9863a9d195180b8d093cc2e81a810c8997bf82b2ee57"
    sha256 cellar: :any_skip_relocation, big_sur:        "da3e3a3799fb9f3a9a7a9863a9d195180b8d093cc2e81a810c8997bf82b2ee57"
    sha256 cellar: :any_skip_relocation, catalina:       "da3e3a3799fb9f3a9a7a9863a9d195180b8d093cc2e81a810c8997bf82b2ee57"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0f6cd55019a764fbbce79f2ab85feb932b0a6b7eb3be5b19f6282f686d069d3"
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
