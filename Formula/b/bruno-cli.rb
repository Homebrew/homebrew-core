class BrunoCli < Formula
  desc "CLI of the open-source IDE For exploring and testing APIs"
  homepage "https://www.usebruno.com/"
  url "https://registry.npmjs.org/@usebruno/cli/-/cli-2.12.0.tgz"
  sha256 "1de4a3012e2d54d607e2dcd7de002f099bed66c5bd535b2234dca52ce13c9e30"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "12e08d991b52c8e367f671ae3340e3069d0a09815d3504c62935297d5c4c8819"
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
