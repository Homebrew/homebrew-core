class BrunoCli < Formula
  desc "CLI of the open-source IDE For exploring and testing APIs"
  homepage "https://www.usebruno.com/"
  url "https://registry.npmjs.org/@usebruno/cli/-/cli-2.14.2.tgz"
  sha256 "a2ba54a0d1096658f952eabb18335f2a701d7ffe779b7c59f905beed360a06c1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7dbf8bd6e0413e7c4e38307a2a4e9ad01b07a2f1a2ef0f635c43e06edf27b432"
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
