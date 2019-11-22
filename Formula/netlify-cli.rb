require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-2.21.0.tgz"
  sha256 "53e3c0725bbc82c0c403bc296d6ff86f118bcf203a4265b80f279fa550ca9e17"
  head "https://github.com/netlify/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "050a8436a18168ae7c2e3b00b69d3f4ded72f1fc73a6b52b50e3a02707c019fa" => :catalina
    sha256 "a1ddc5be17db8d8007b6ed6b102607157805f3e04c2e31e17bda2731cabc6641" => :mojave
    sha256 "7a8a5585b1e4ed4f752978547609cd17dfb23e1137976289b57d96db5bb3b20d" => :high_sierra
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
