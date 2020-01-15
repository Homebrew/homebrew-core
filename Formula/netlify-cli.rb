require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-2.29.0.tgz"
  sha256 "f606ae8a98d07071a36d36333956bdf3153e9e641f790cbdceec6c647cc62bf1"
  head "https://github.com/netlify/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ca73481385cad26c71fb7e806db7b4a00048dae9e28eda4fc9da5d846662d384" => :catalina
    sha256 "5dc0326e7e906bed9bdcc687866be63f99635cd4efb2be349e16c60a0deddb16" => :mojave
    sha256 "aadfaba348ee0af9c16ad7078ccd3d2bf6657fd415eae1f1d56d953148ceb73c" => :high_sierra
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
