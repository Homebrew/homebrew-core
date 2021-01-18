require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-3.2.3.tgz"
  sha256 "4c42a3159b4de0974d2dcfd1f64752495163cf4775c8653b7b2a334fe8792c44"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "0d119f727dec11bcb961bc0d10ec94b1b486eead19677e09b405cdeb44bad317" => :big_sur
    sha256 "eca867f743502e0a1d3f5ebaa277835c0332c985e6b3836a1bf877e4c0b2510f" => :arm64_big_sur
    sha256 "9d4e077cd24b42bf3ab2cbbfec584bcff7d2219ccbc33866dace0a09f98029cc" => :catalina
    sha256 "b73d2d309e6189e57fd45f235a1dd66590f4c4de3ce85f1cbb65d2889707a999" => :mojave
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
