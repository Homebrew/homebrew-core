class Mailsy < Formula
  desc "Quickly generate a temporary email address"
  homepage "https://github.com/BalliAsghar/Mailsy"
  url "https://registry.npmjs.org/mailsy/-/mailsy-5.0.0.tgz"
  sha256 "ab89f60c2472f4b20ad7c507cff4653de6bd28411a39bfd9435829a1ad534414"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "b3020835bf4bc4375afaf73df846d48e805448377b4a8013ae8e59480cf4981b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5eb1d27527f9b27d2bbd577ef5805e696d9b64b95d3db4f8f025899fda4d9289"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5eb1d27527f9b27d2bbd577ef5805e696d9b64b95d3db4f8f025899fda4d9289"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5eb1d27527f9b27d2bbd577ef5805e696d9b64b95d3db4f8f025899fda4d9289"
    sha256 cellar: :any_skip_relocation, sonoma:         "0ffc5714684754005b04200b5f379adb9fe3fd861d92b6cb64300065543f7205"
    sha256 cellar: :any_skip_relocation, ventura:        "0ffc5714684754005b04200b5f379adb9fe3fd861d92b6cb64300065543f7205"
    sha256 cellar: :any_skip_relocation, monterey:       "0ffc5714684754005b04200b5f379adb9fe3fd861d92b6cb64300065543f7205"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "7f7edbd95c0eeb40083f65f01a87f3cef1a2aa2500258712a3c342353ff8e180"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70af352d946453cfea208005eb47d49d7f9284dc9fb899169b520d9dd8586a98"
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
