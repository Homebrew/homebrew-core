require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-8.6.0.tgz"
  sha256 "c669d40cde0eb2da4069a03bf4e355d862b976ee6a3592a8d2d994222c8b8e77"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d5a2049f13bb66a47a817b54bf9a44be1d10680bbf3f7022e4c5c8edb7409228"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d5a2049f13bb66a47a817b54bf9a44be1d10680bbf3f7022e4c5c8edb7409228"
    sha256 cellar: :any_skip_relocation, monterey:       "19dd37b939461ff889bab1a95928a87bf749378d31d3a567e7a12fd94c87e144"
    sha256 cellar: :any_skip_relocation, big_sur:        "19dd37b939461ff889bab1a95928a87bf749378d31d3a567e7a12fd94c87e144"
    sha256 cellar: :any_skip_relocation, catalina:       "19dd37b939461ff889bab1a95928a87bf749378d31d3a567e7a12fd94c87e144"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92f902f9a010a36623de57df5fc62eac08629cd9850fd7afa6e135a1cc53ceef"
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
