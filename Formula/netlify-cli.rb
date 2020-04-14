require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-2.46.0.tgz"
  sha256 "5e9f257d66f9b02ef7e100b30500c9027fd54adb3b86834a7440a98cefcc4705"
  head "https://github.com/netlify/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "527f93f889fff89c35267a65770d023284158968d1d8c4938827253b2d67df42" => :catalina
    sha256 "fc1b271c6f82442eada8e1b3808969584ca19fc5df084cff42f3685266bf96eb" => :mojave
    sha256 "92f01be71781c8c80dc634d65287a20b7bd4ccb9f4b4947b24d8d91a8795a0e9" => :high_sierra
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
