class BrunoCli < Formula
  desc "CLI of the open-source IDE For exploring and testing APIs"
  homepage "https://www.usebruno.com/"
  url "https://registry.npmjs.org/@usebruno/cli/-/cli-2.15.0.tgz"
  sha256 "b3565a0fee13589716f7228870f192f08f60791a1325ca8cd26964e1bd850bf2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f4f575d099f5f0e4417389065ebe6b3db18320c24360bdaaa1fe03ac51d67145"
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
