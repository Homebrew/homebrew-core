class BrunoCli < Formula
  desc "CLI of the open-source IDE For exploring and testing APIs"
  homepage "https://www.usebruno.com/"
  url "https://registry.npmjs.org/@usebruno/cli/-/cli-3.5.0.tgz"
  sha256 "b2a635dc8f7039bd6ead25a2bfb1a0dd22927868a938d4e6b9f400e98b4ce349"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bf6fd0d9d68c32691cbf20561c96d17ec9e57c1487aff06674f6a8b4ae00eff6"
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
