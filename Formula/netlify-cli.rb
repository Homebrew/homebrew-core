require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-2.69.10.tgz"
  sha256 "c24027485eb5bb72cb6ebeca088b731dd107ce5110f32073249cc1acda6c4ee8"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "a455b115c97aecf0295390d932d911cf5016dbb8428ed4d0e2997fccbb0ff0ef" => :big_sur
    sha256 "ec67c1b447bc17bad7caf20fbe6f810aaf459fab20ea4d7866348f73a68d7793" => :catalina
    sha256 "8e90dd24c7865c01d1406fa95f4f98e19d8a7ead25558a77f815f2bb8aa0597c" => :mojave
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
