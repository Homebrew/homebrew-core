require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-3.2.1.tgz"
  sha256 "9871ba386d7ff63e0dbf9dd0f776b6b0c7095c324cf109c3369b447e0d970635"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "58bac8c30767a29973fe7df77aef5f049c6853794c7cf9eba7f87574dd30022f" => :big_sur
    sha256 "80fb77bfcaa56868acdfe562e03d2bd1d25fb56d524e9ad36305c8614ed8241d" => :arm64_big_sur
    sha256 "5346f3482ed3e9c5b302625778d86422bd664e0a40c3c2ca8354f9360c819bbe" => :catalina
    sha256 "6a7187f0d2f0ea769640a331abab404dedf446a7e4db4a0bd09281faf39a394f" => :mojave
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
