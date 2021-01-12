require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-3.1.0.tgz"
  sha256 "255f16c5d0492e5004253181510cf471af4948240ce6996427597792f211d8dc"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "744444f8eda0ffc2f4963107245088f2cc0674d557a8a98546ea889e188f7857" => :big_sur
    sha256 "7306c16be08940128d4a8a781ec6863e32542c13c0af3232ce41e9276d316d7d" => :arm64_big_sur
    sha256 "c5ac75f77ce6a299527a6f578d3bf31d59d1aeecfbc2ba70fdffbd1dbdbbac0f" => :catalina
    sha256 "0e42cf104ec71774f2cdce930e7544f0083bea63e80e21089abff79c5de4d39f" => :mojave
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
