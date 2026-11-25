class BrunoCli < Formula
  desc "CLI of the open-source IDE For exploring and testing APIs"
  homepage "https://www.usebruno.com/"
  url "https://registry.npmjs.org/@usebruno/cli/-/cli-4.4.0.tgz"
  sha256 "1ea90e2a2a3843a58f2f02dd1a6172d8e605959af5829509e9ad3f76aff1abc3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1ac88f21c6505b267845ecded2ab5cf53d9fb389424e7289b29495a07754eaa8"
  end

  depends_on "node"

  allow_network_access! :build

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
