require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-3.4.2.tgz"
  sha256 "b8e57777f837447e4afe95857c0ab6cbfa2f1af6ff00141d1bf65fc90f8de32f"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "7a8be14894885fc5f6f5e171c43fc538ded16840217dcdee94868431d3dcd2c7" => :big_sur
    sha256 "9c89c5a3cd6327760ecd9ab18e21aae85647ab54cd16e70e3d8aa290cf0fdc3d" => :arm64_big_sur
    sha256 "e6c6cf21605f30b78ca652958e472ac369a1aa3abd1dba269a6bcdb8ae597ad5" => :catalina
    sha256 "1a3282362283b8b971b45f09d11d2011933d5eb5081887b25903250fa7956ae0" => :mojave
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
