class BrunoCli < Formula
  desc "CLI of the open-source IDE For exploring and testing APIs"
  homepage "https://www.usebruno.com/"
  url "https://registry.npmjs.org/@usebruno/cli/-/cli-4.0.0.tgz"
  sha256 "f3eee310c779436b2a1b8b6f018775eca8b1c8483fac136a15f474e8b647f225"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "cb3a26df553bd0d2af1af93fb500c2cc56041d87e58dac452cf28f5a1fd5b408"
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
