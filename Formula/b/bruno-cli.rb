class BrunoCli < Formula
  desc "CLI of the open-source IDE For exploring and testing APIs"
  homepage "https://www.usebruno.com/"
  url "https://registry.npmjs.org/@usebruno/cli/-/cli-3.0.2.tgz"
  sha256 "d068be45a6d00c6fc46627fcd7a616317293eb0e188ac6abb3216b5a390f9239"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "629ad434c7589cfb86e744c483f99b11ae902e8d410f6897e6723515ec02b4d8"
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
