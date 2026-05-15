class BrunoCli < Formula
  desc "CLI of the open-source IDE For exploring and testing APIs"
  homepage "https://www.usebruno.com/"
  url "https://registry.npmjs.org/@usebruno/cli/-/cli-3.3.0.tgz"
  sha256 "b2ace10243eb2de0fb6d0bbb1039163b851f4c01442ba9fca9d983a8edb18bc0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1a7cfaa60c1a828477b08ec59f3c37d6ae76f5e0db57caee8225dad0a45f704d"
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
