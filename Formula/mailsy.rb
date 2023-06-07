require "language/node"

class Mailsy < Formula
  desc "Quickly generate a temporary email address"
  homepage "https://github.com/BalliAsghar/Mailsy"
  url "https://registry.npmjs.org/mailsy/-/mailsy-4.0.0.tgz"
  sha256 "55b55e5e631005b451c320cb2a689e5b1c2347422b8696ea847f691cdef0a500"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2514b6b84c2c0d5a632b316c98af3111c96731f92fb6aadf8e10fbebc085f899"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2514b6b84c2c0d5a632b316c98af3111c96731f92fb6aadf8e10fbebc085f899"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2514b6b84c2c0d5a632b316c98af3111c96731f92fb6aadf8e10fbebc085f899"
    sha256 cellar: :any_skip_relocation, ventura:        "e7eaa1cbb7ee39d0bcd8fcfb4c7ace25c7cc4b12c3eebaa4716b44f6054991fd"
    sha256 cellar: :any_skip_relocation, monterey:       "e7eaa1cbb7ee39d0bcd8fcfb4c7ace25c7cc4b12c3eebaa4716b44f6054991fd"
    sha256 cellar: :any_skip_relocation, big_sur:        "e7eaa1cbb7ee39d0bcd8fcfb4c7ace25c7cc4b12c3eebaa4716b44f6054991fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2514b6b84c2c0d5a632b316c98af3111c96731f92fb6aadf8e10fbebc085f899"
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
