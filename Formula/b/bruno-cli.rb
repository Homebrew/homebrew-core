class BrunoCli < Formula
  desc "CLI of the open-source IDE For exploring and testing APIs"
  homepage "https://www.usebruno.com/"
  url "https://registry.npmjs.org/@usebruno/cli/-/cli-3.0.3.tgz"
  sha256 "633b826d7b5433d17a7f06bf945898db3bf1e968fc5c01b737f70ddcabdfebce"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "10d629b31b981596a978c10d95c44699a930de9c635f2a5a287e9e0da71907d4"
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
