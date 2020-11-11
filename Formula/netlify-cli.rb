require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-2.68.4.tgz"
  sha256 "75b3361be495428880ac01d89982b9ea38ab19b485af346022b72b4bf3aec90f"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "194cd97b59be5a3e431316447ed7de0368107abb4f4c5c3f781bb74a90fd7104" => :catalina
    sha256 "d31c0cd829032d9c75bc388b7946b98753259a8b84f47175f475f65419b09d7c" => :mojave
    sha256 "5fb0d2389bf503c171f220530e53251b5fbfdd96dd7df680775d3fb02e6ad72b" => :high_sierra
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
