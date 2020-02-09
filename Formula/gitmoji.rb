require "language/node"

class Gitmoji < Formula
  desc "Emoji guide for your commit messages"
  homepage "https://gitmoji.carloscuesta.me"
  url "https://registry.npmjs.org/gitmoji-cli/-/gitmoji-cli-3.2.1.tgz"
  sha256 "a5a7304466bbf8eb3c5360262df19a0543d711ee2df9f1ee268103c81cf47784"

  bottle do
    cellar :any_skip_relocation
    sha256 "4b96cb3e23f90b5fb58eff364090f6014a5bc0a9f7e4e74fd6627d1b8b668658" => :catalina
    sha256 "f277533e688b463fb6300e3ea66fb3a78d9c62fa66c32c7c81646d18b0fa266f" => :mojave
    sha256 "16be1212a53e4299bf2ec78ad2ce9ed9d7383350135e423a5406366c6e9499e3" => :high_sierra
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
