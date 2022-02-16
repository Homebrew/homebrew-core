require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-9.6.0.tgz"
  sha256 "46c57603f9f0884f304cf76827e8b656c983e35fcfc308281c996c06b4ea828c"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a7d6eb34dc83c23b9984f37ccb1886847df1956210270781579478792dcf8462"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a7d6eb34dc83c23b9984f37ccb1886847df1956210270781579478792dcf8462"
    sha256 cellar: :any_skip_relocation, monterey:       "90b6be1f1059e6d58b4af5b611c6759cc04f40f5f3c0daa1349bb1bf35dd2b69"
    sha256 cellar: :any_skip_relocation, big_sur:        "90b6be1f1059e6d58b4af5b611c6759cc04f40f5f3c0daa1349bb1bf35dd2b69"
    sha256 cellar: :any_skip_relocation, catalina:       "90b6be1f1059e6d58b4af5b611c6759cc04f40f5f3c0daa1349bb1bf35dd2b69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0f1d16a43f7e2620cde38d6a85b3cb361142a81d993c6483c657de0d7281833"
  end

  depends_on "node"

  uses_from_macos "expect" => :test

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.exp").write <<~EOS
      spawn #{bin}/netlify login
      expect "Opening"
    EOS
    assert_match "Logging in", shell_output("expect -f test.exp")
  end
end
