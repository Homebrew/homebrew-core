require "language/node"

class Mailsy < Formula
  desc "Quickly generate a temporary email address"
  homepage "https://github.com/BalliAsghar/Mailsy"
  url "https://registry.npmjs.org/mailsy/-/mailsy-4.0.0.tgz"
  sha256 "55b55e5e631005b451c320cb2a689e5b1c2347422b8696ea847f691cdef0a500"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7895f343f6290912eec520fbdce9015a7b2ba401feda5f3351e2282a530220a1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "10e9485d0cc9c2be2ae1434d55bc4465e30c2f550f3ae804b996e553b250cfbf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "10e9485d0cc9c2be2ae1434d55bc4465e30c2f550f3ae804b996e553b250cfbf"
    sha256 cellar: :any_skip_relocation, ventura:        "b75dc7896a57826a9cbb8257e84726b12bd13dcbe7d8ff84c4bb217ff4301d6f"
    sha256 cellar: :any_skip_relocation, monterey:       "a64208278b48c0c6706464b01c7bb8ea29b444cd676926c5fcab518606831d81"
    sha256 cellar: :any_skip_relocation, big_sur:        "a64208278b48c0c6706464b01c7bb8ea29b444cd676926c5fcab518606831d81"
    sha256 cellar: :any_skip_relocation, catalina:       "a64208278b48c0c6706464b01c7bb8ea29b444cd676926c5fcab518606831d81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10e9485d0cc9c2be2ae1434d55bc4465e30c2f550f3ae804b996e553b250cfbf"
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
