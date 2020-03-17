require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-2.40.0.tgz"
  sha256 "c7b89b21e815da021e128633ef4b060e2373f59c53a5f14272982aa3efca6ea2"
  head "https://github.com/netlify/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "177809a40c4219cae22519a2e5dc1aa270d9b79225772643a17130fbc3e9b822" => :catalina
    sha256 "2e6ea2bba354b078986a13aa1775511845eac4798d3733dd81157d71d64188ab" => :mojave
    sha256 "20aa05f3bf60fa367b17f7403d5ba4fe1f1a971d39b35c60f46cee0c9ef200de" => :high_sierra
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
