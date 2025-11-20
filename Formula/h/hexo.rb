class Hexo < Formula
  desc "Fast, simple & powerful blog framework"
  homepage "https://hexo.io/"
  url "https://registry.npmjs.org/hexo/-/hexo-8.1.1.tgz"
  sha256 "c414b9b5e70643c0488dcef4e9440662c36f8b5a67ed399f09a0e4feba1c173c"
  license "MIT"
  head "https://github.com/hexojs/hexo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2c6f2cc571e1e498c3ce32d4c3dcf162a70cf7e8d9db2c0046ef58a971972376"
  end

  depends_on "node"

  def install
    mkdir_p libexec/"lib"
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/hexo --help")
    assert_match "Usage: hexo <command>", output.strip

    output = shell_output("#{bin}/hexo init blog --no-install")
    assert_match "Cloning hexo-starter", output.strip
    assert_path_exists testpath/"blog/_config.yml"
  end
end
