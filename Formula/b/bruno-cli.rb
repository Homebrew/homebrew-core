class BrunoCli < Formula
  desc "CLI of the open-source IDE For exploring and testing APIs"
  homepage "https://www.usebruno.com/"
  url "https://registry.npmjs.org/@usebruno/cli/-/cli-3.5.2.tgz"
  sha256 "7f6945e6b376c3d2b0d277169f5e6d057fd93ca2352162794c9c50b060fdacec"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "71b88be69b952154925c61e6f9ef54c89ba90ed588dbc34436836e8713070d32"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    # supress `punycode` module deprecation warning, upstream issue: https://github.com/usebruno/bruno/issues/2229
    (bin/"bru").write_env_script libexec/"bin/bru", NODE_OPTIONS: "--no-deprecation"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bru --version")
    assert_match "You can run only at the root of a collection", shell_output("#{bin}/bru run 2>&1", 4)
  end
end
