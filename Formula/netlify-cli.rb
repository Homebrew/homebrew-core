require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-2.65.5.tgz"
  sha256 "d26ea1799adc24a357a7ebb96e32b0f02b14a177ed5063a7642409e0756af372"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "8137cd5d416da33cde21590d91cfc1677956627367de21cc367d78b9e6fbca3f" => :catalina
    sha256 "131ac7a55df1347229179bcf93bf83a99e24a6956fcfead499afd7b64e5315f2" => :mojave
    sha256 "2b400445ceee9366560064d4f0a5d8bf6374e1931510b5dd15872f0bc7d97695" => :high_sierra
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
