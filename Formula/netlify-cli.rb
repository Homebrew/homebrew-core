require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-2.69.8.tgz"
  sha256 "db9f3d61922f9a04c99cfc21a761b9871facc39baabb59d98dfed8f7372a286e"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "f38559d36355588a57ffd3b3149f78c9f13996f1edb45f450f652690db00edef" => :big_sur
    sha256 "cd59d9eca77e898a2513939dfd6a865d0558001bf825fea8b4bfa153f549be62" => :catalina
    sha256 "9b74caf7d0e89ad922a297a572deafea96b58f4c6533629ec9d25212074bc708" => :mojave
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
