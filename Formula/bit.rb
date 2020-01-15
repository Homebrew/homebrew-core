require "language/node"

class Bit < Formula
  desc "Distributed Code Component Manager"
  homepage "https://bit.dev"
  url "https://registry.npmjs.org/bit-bin/-/bit-bin-14.7.2.tgz"
  sha256 "98ef0d7a81886afd08ec91a46fa98f4ddbe7ca676a2319d983b8eedc2d895984"
  head "https://github.com/teambit/bit.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b76f557d4486f3afb1998f158b877b5fd00cb1e9aa5cb9cf118c5d33c79ebd9b" => :catalina
    sha256 "70d4fc59f7c78fad2901f31d77006a9b54afb3c5169a0f854687a37e221b0e7a" => :mojave
    sha256 "ae5bc5119ba376b93d822677e4befdd9f880b588338c7931edba595de30276cf" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"Library/Caches/Bit/config/config.json").write <<~EOS
      { "analytics_reporting": false, "error_reporting": false }
    EOS
    output = shell_output("#{bin}/bit init --skip-update")
    assert_match "successfully initialized", output
  end
end
