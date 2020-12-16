require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-2.69.9.tgz"
  sha256 "acb146749ef170a8ea9a342b13c0ff9d949800fc8bafee6fa25347a9626c550d"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "aa90e8e25e9d330b601e3624310a15b5eef0a99fd4334c16f8095c9086fa2475" => :big_sur
    sha256 "1575034f9056eb2092e908ffa90f1cfd0999ea2befb8b7cacac4b3305899c99f" => :catalina
    sha256 "8b5db861f458a1d5c196d19bcdef67d19241d7396d72278abc111fefdcd7a3d7" => :mojave
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
