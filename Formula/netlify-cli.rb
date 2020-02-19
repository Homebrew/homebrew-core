require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-2.33.0.tgz"
  sha256 "059f472be466aca6b37d1fd66df113572a8ad4a012dd79d5bd1f786001981256"
  head "https://github.com/netlify/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5610c95d9e7eb318ee6b8c82a3df2866ad105e9246a8456f9a76aa8ff395a572" => :catalina
    sha256 "e5c454f1acf2ce59d764295f569d1723d53ac69d0e00a4401e43468d11528fa2" => :mojave
    sha256 "e5af5e51b83a67235114e3e9478ba21a6be33e7940a7804894ae870213dad89c" => :high_sierra
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
