class Mailsy < Formula
  desc "Quickly generate a temporary email address"
  homepage "https://github.com/BalliAsghar/Mailsy"
  url "https://registry.npmjs.org/mailsy/-/mailsy-5.0.0.tgz"
  sha256 "ab89f60c2472f4b20ad7c507cff4653de6bd28411a39bfd9435829a1ad534414"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "458e2530def02e452e870febacbd9fa372d0c504b16b721ab0610fd4e57043f2"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Account not created yet", shell_output("#{bin}/mailsy me")
    assert_match "Account not created yet", shell_output("#{bin}/mailsy d")
  end
end
