class BrunoCli < Formula
  desc "CLI of the open-source IDE For exploring and testing APIs"
  homepage "https://www.usebruno.com/"
  url "https://registry.npmjs.org/@usebruno/cli/-/cli-2.14.4.tgz"
  sha256 "a27ea326e33d157d8e181209baff72a383744321b9de6c2f7ec8fb298b963984"
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
