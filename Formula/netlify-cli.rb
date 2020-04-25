require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-2.48.0.tgz"
  sha256 "3fcc90051023aa9b322901c4fb0099f521df8ef9502b8659bdd29f76116952a6"
  head "https://github.com/netlify/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2b7f24ce3c1df20f6f4a70c0196fb8c25c12bb36680fd79295c308564698172c" => :catalina
    sha256 "88bd0f7c7ae97891299b9e9c9e812140fd411df993c377ea3368b51994c392f8" => :mojave
    sha256 "4f95d9a06a74d8a020f31828bee36c70802e89bf22407675d0572916a917ecd8" => :high_sierra
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
