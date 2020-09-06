require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-2.61.1.tgz"
  sha256 "a7cf7865941d39909502c6a5bbe438ce94969708be63843bbf8441e94aa6578b"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "bac44e863bc647707cded1ed826d2d5f1251269c39bf6ad691901b053e9f296d" => :catalina
    sha256 "1ed0ff630a4578e904e82644b9604f054230bb5aed5dbd06a7607870c0bb4b3b" => :mojave
    sha256 "04735df1f7514ea891b64ddc4a3aa2fc40ea2f993e4431dc6f0350b2c0dfcafc" => :high_sierra
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
