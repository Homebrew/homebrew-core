require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-2.65.7.tgz"
  sha256 "99ba81d59769aebf1e5c0ae5f58d3d509ba4121a8cd8081bd98245c2b829e527"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "66d2ad4fafe049e0b558ca65cca4ae5f6263530ce9431787b62831cdef3d694c" => :catalina
    sha256 "10113b36f3d764985c0093aca56b06aa280791a5dc960cb79a989d533cb19bdc" => :mojave
    sha256 "663ff2b66adb7ede2a9f8cef1e4a7b3b1c99dd80e0492da623a0c1ea00a4aff4" => :high_sierra
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
