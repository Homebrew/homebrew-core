require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-2.19.0.tgz"
  sha256 "6b304fe2319f896b2723ab62d84d56faf61eba9fc4fbd8e3fdf3a98a8f62d0ee"
  head "https://github.com/netlify/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bbe9e9fb103101c2fbbf99c6a27df648a7481201696ed8f94ac66df975b9ccc4" => :catalina
    sha256 "7db1375db620196579b161531087642e254ceb44a2d271dd6231c39b145a45d1" => :mojave
    sha256 "ed1c4c0680fc97cb50c67b38e03a899eeeeeb8fd2a5f50cd48d98740e043f256" => :high_sierra
  end

  depends_on "node"

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
