class BrunoCli < Formula
  desc "CLI of the open-source IDE For exploring and testing APIs"
  homepage "https://www.usebruno.com/"
  url "https://registry.npmjs.org/@usebruno/cli/-/cli-3.5.1.tgz"
  sha256 "e0e5c585a39d12b9051ec2d359ab94e50098c2ad33131d4c293bcaa823c1f43d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "cb60ee6dd344d694e33c1297f1382472e3f18c9b4b17e3be714ed5a9c9e6d736"
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
