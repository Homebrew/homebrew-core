require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-9.13.0.tgz"
  sha256 "f81c7d48a24c7f18bc0f012f7dca6e790a4c25e544f8a542ac7697f9ed755b65"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b04cd58f497da046af0c2bd8fdcb2b87c568da1589c6ce6ef98fe643106885a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2b04cd58f497da046af0c2bd8fdcb2b87c568da1589c6ce6ef98fe643106885a"
    sha256 cellar: :any_skip_relocation, monterey:       "d0431aac03692d693e017914cb0f5f06011b44f7c00bf4f04e4c9247d31d925a"
    sha256 cellar: :any_skip_relocation, big_sur:        "d0431aac03692d693e017914cb0f5f06011b44f7c00bf4f04e4c9247d31d925a"
    sha256 cellar: :any_skip_relocation, catalina:       "d0431aac03692d693e017914cb0f5f06011b44f7c00bf4f04e4c9247d31d925a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "718ef3725a611ac13a5609596594cc769aa6eaf52a2848e0b6f578bc527f90db"
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
