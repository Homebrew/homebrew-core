require "language/node"

class Mailsy < Formula
  desc "Quickly generate a temporary email address"
  homepage "https://github.com/BalliAsghar/Mailsy"
  url "https://registry.npmjs.org/mailsy/-/mailsy-5.0.0.tgz"
  sha256 "ab89f60c2472f4b20ad7c507cff4653de6bd28411a39bfd9435829a1ad534414"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d2357b5195209ef548ce98d31946ecf9afe4dbbb5fdf640e16803cb2a556dffc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "47d9a9435a1925bfecb00a010e57e0f4049e79a545b65a8272756e37148fb0ce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c623fde0223de29670ccd17225b1cc8d063d4204843677c91f0d8bcccb6fe22b"
    sha256 cellar: :any_skip_relocation, sonoma:         "cc2bec90eeb727baffc2996076d2c7011cb20f78e32dd1dd93d69fafcd5949b7"
    sha256 cellar: :any_skip_relocation, ventura:        "cb0fcd46801b360436044ea122b986945bf42c803160d0be4475b6b381b29cd3"
    sha256 cellar: :any_skip_relocation, monterey:       "f64fba3f040d4d4d50d881a17be7b3df664fd00848d5f8c22290b6aad58a112c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "05e03b250aa09b7cc2c05e86dafc61b49fbf719aaa4e8ec7e952087bb81839f2"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Account not created yet", shell_output("#{bin}/mailsy me")
    assert_match "Account not created yet", shell_output("#{bin}/mailsy d")
  end
end
