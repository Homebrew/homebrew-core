require "language/node"

class Gitmoji < Formula
  desc "Emoji guide for your commit messages"
  homepage "https://gitmoji.carloscuesta.me"
  url "https://registry.npmjs.org/gitmoji-cli/-/gitmoji-cli-3.2.18.tgz"
  sha256 "c4db0d01e8bb7b62cf424d6b2d9fd70225bc5ebc9111b2feaf274b64d6db3884"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "029db9f23be973dc52e2f5928bf4c7464c64f314abf54f1942dab7b07137b811" => :big_sur
    sha256 "169ae899ea8ea13de67aa8f4d184ada75e74555b2036130ae53df0bacac3e161" => :arm64_big_sur
    sha256 "07010e9161a7c81d694a8d4c769451edb3ef7a84e3bb03c272c6fe0e97e2a774" => :catalina
    sha256 "cb2deb16eb9acee309cda78e5a336e29fcf99073195ed9aa9bdc244954ce45c9" => :mojave
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match ":bug:", shell_output("#{bin}/gitmoji --search bug")
  end
end
