require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-6.9.30.tgz"
  sha256 "0d6cdf70e2072758f9d0aa03bd1dfa35dd43ea69b9d92f6d9369aa2b80cc763f"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "73b12a8c2052e6d588ee86ee4e1848d9f5dda94edf360e8405b98337d6b3046b"
    sha256 cellar: :any_skip_relocation, big_sur:       "3979f415257537c299b236ef2a80696bb629ec852d61d24645d4b74ba6c660cb"
    sha256 cellar: :any_skip_relocation, catalina:      "3979f415257537c299b236ef2a80696bb629ec852d61d24645d4b74ba6c660cb"
    sha256 cellar: :any_skip_relocation, mojave:        "3979f415257537c299b236ef2a80696bb629ec852d61d24645d4b74ba6c660cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "79980a1c9c2f6be77faa83be0c7c989bf3a25aba2e479612f063d32d2239b3cc"
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
