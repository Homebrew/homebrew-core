require "language/node"

class Hexo < Formula
  desc "Fast, simple & powerful blog framework"
  homepage "https://hexo.io/"
  url "https://registry.npmjs.org/hexo/-/hexo-6.1.0.tgz"
  sha256 "c3cbaa3a4d72ccadf1125762895c2714e8474099c9da73c60bd766f17f92fac4"
  license "MIT"
  head "https://github.com/hexojs/hexo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "51cfa7221ff46fb99c3251d5404b883624f8bb05208a62c50dd08201c47bf6c9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "51cfa7221ff46fb99c3251d5404b883624f8bb05208a62c50dd08201c47bf6c9"
    sha256 cellar: :any_skip_relocation, monterey:       "bed14d2c4ad5ef76e1f88ee2442aaedab6637f5eab782ec31d7d40df1938ae97"
    sha256 cellar: :any_skip_relocation, big_sur:        "bed14d2c4ad5ef76e1f88ee2442aaedab6637f5eab782ec31d7d40df1938ae97"
    sha256 cellar: :any_skip_relocation, catalina:       "bed14d2c4ad5ef76e1f88ee2442aaedab6637f5eab782ec31d7d40df1938ae97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f3eeee251eac6927419ca643102c4faccaa1091360cc9dd6f6f190c39ff6913e"
  end

  depends_on "node"

  def install
    mkdir_p libexec/"lib"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Replace universal binaries with their native slices.
    deuniversalize_machos
  end

  test do
    output = shell_output("#{bin}/hexo --help")
    assert_match "Usage: hexo <command>", output.strip

    output = shell_output("#{bin}/hexo init blog --no-install")
    assert_match "Cloning hexo-starter", output.strip
    assert_predicate testpath/"blog/_config.yml", :exist?
  end
end
