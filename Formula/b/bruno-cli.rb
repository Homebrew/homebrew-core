class BrunoCli < Formula
  desc "CLI of the open-source IDE For exploring and testing APIs"
  homepage "https://www.usebruno.com/"
  url "https://registry.npmjs.org/@usebruno/cli/-/cli-2.11.0.tgz"
  sha256 "08122a463524fea2a16faf743f5f9f1689050e9dc535e5fd13bbe16cfd451f48"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1c96d287341827302cfb1d237e2867ea614d639680dad985183e500a8cb05565"
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
