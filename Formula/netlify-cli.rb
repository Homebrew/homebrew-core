require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-3.4.1.tgz"
  sha256 "d28b3779ec92bf431e0ff4ec7bd81e07ac01759ba04d7ea1a68070377840c6de"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "513e22c4ea2fda2439eb84a6f99b311148d5d0a6cfde515c381d499b205219be" => :big_sur
    sha256 "7ad10e7617c4270c4fba97e17f15aa0713735eefb161b55817bc4ded76325cc7" => :arm64_big_sur
    sha256 "8008513769059c0116f435f8546055303f3896492a4f880d87c841c530c06d40" => :catalina
    sha256 "3988736b8e779f30b03476c21b22fce2c94d883024c9e9540822a50836ff0c4a" => :mojave
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
