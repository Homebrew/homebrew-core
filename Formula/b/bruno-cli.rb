class BrunoCli < Formula
  desc "CLI of the open-source IDE For exploring and testing APIs"
  homepage "https://www.usebruno.com/"
  url "https://registry.npmjs.org/@usebruno/cli/-/cli-2.2.2.tgz"
  sha256 "8bcd0de0c3ce7d94179e4385d07f7f7936f869cb1d5333a9f4bf7c8f9b655853"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ceb72d20e15cc304fd75e17fd7f700723616926e5fefbb6b47d948e5f8b55ce8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ceb72d20e15cc304fd75e17fd7f700723616926e5fefbb6b47d948e5f8b55ce8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ceb72d20e15cc304fd75e17fd7f700723616926e5fefbb6b47d948e5f8b55ce8"
    sha256 cellar: :any_skip_relocation, sonoma:        "4537f64a47548d79162b248e8e1d41f537e7f7b44b7dccad206bf8f28d2da88a"
    sha256 cellar: :any_skip_relocation, ventura:       "4537f64a47548d79162b248e8e1d41f537e7f7b44b7dccad206bf8f28d2da88a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ceb72d20e15cc304fd75e17fd7f700723616926e5fefbb6b47d948e5f8b55ce8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ceb72d20e15cc304fd75e17fd7f700723616926e5fefbb6b47d948e5f8b55ce8"
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
