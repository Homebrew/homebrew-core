require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-2.71.0.tgz"
  sha256 "baae2ac7da9da061d279e6fcb4353238cc560eb7f91fc5bba9451822e0c583c9"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "dfe1916b32b4d1fb08f79569bd5a3be4e097c0e7b99b7a0f48d0f59b01b5e9dd" => :big_sur
    sha256 "4ed43f45b1619ad91f7ad77d1da3db995f66d22acf44625268fdcd39336fb8ad" => :arm64_big_sur
    sha256 "9c11d01a6535f2514a19ace0d715116c7f41d8c62514a38990358871fe7fd793" => :catalina
    sha256 "dd00d883b6d35cf8d9e4f10dd3f03dc61d451e5e067c3b23d650c797e9f4425d" => :mojave
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
