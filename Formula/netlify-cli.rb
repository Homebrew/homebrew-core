require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-2.27.0.tgz"
  sha256 "273674741e5baca0183cdf5a85bb4527eda475d2fc15ab66fb8080206d38d156"
  head "https://github.com/netlify/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5e8a556610f5976db0e2125417bc190c9e3bf4785e1064119bea8cb1ea1b025b" => :catalina
    sha256 "45698cbd30d95f0cfb4e7c0e397d7347b2f62a6052f92e0d85507a6a0a5f1c7f" => :mojave
    sha256 "a560fda854b5404a608894dee59dcf5bafa050d34302715556ab488174806185" => :high_sierra
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
