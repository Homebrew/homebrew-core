require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-9.4.0.tgz"
  sha256 "ff56e48403243f56296b16ea5569aca4eb5b273babf0eb64889b80f2f4188a06"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee0d4b2930eb05ccd01ca13a6e60f5415ea3d5b4d9e56bd9b3896f4ffa9e6442"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ee0d4b2930eb05ccd01ca13a6e60f5415ea3d5b4d9e56bd9b3896f4ffa9e6442"
    sha256 cellar: :any_skip_relocation, monterey:       "cf40c44fe2babc7c983f2381dca57587c20c74e0328c6f2516b44b9dc49f4da1"
    sha256 cellar: :any_skip_relocation, big_sur:        "cf40c44fe2babc7c983f2381dca57587c20c74e0328c6f2516b44b9dc49f4da1"
    sha256 cellar: :any_skip_relocation, catalina:       "cf40c44fe2babc7c983f2381dca57587c20c74e0328c6f2516b44b9dc49f4da1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df6fbb5381aceab2695787c1766d366206a9500505edc26385c1c3353f7fa575"
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
