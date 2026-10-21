class BrunoCli < Formula
  desc "CLI of the open-source IDE For exploring and testing APIs"
  homepage "https://www.usebruno.com/"
  url "https://registry.npmjs.org/@usebruno/cli/-/cli-4.2.1.tgz"
  sha256 "3bc39460b5ab85a30e5761c7e07c4dc5db6ac9384b66d171669f9f0eab4fe8ec"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a991f3eac8014c2c22193ded00d86e4e686008b783fabaae4f2e4d4e4c5096b4"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    # supress `punycode` module deprecation warning, upstream issue: https://github.com/usebruno/bruno/issues/2229
    (bin/"bru").write_env_script libexec/"bin/bru", NODE_OPTIONS: "--no-deprecation"
  end

  test do
    assert_match version.to_s, pipe_output("#{bin}/bru --version", nil, 0)
    assert_match "You can run only at the root of a collection", pipe_output("#{bin}/bru run 2>&1", nil, 4)
  end
end
