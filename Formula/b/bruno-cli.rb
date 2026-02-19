class BrunoCli < Formula
  desc "CLI of the open-source IDE For exploring and testing APIs"
  homepage "https://www.usebruno.com/"
  url "https://registry.npmjs.org/@usebruno/cli/-/cli-3.1.2.tgz"
  sha256 "ea39c8d9949e90f1829a48fcae8871bb69a9b924aeac3a3d3cef28fac40ecdcd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "785d1b434522f7f25c665a3c759931270124a85acc37747f9ed3f3b59e4f8daa"
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
