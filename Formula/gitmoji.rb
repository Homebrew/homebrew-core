require "language/node"

class Gitmoji < Formula
  desc "Emoji guide for your commit messages"
  homepage "https://gitmoji.carloscuesta.me"
  url "https://registry.npmjs.org/gitmoji-cli/-/gitmoji-cli-3.2.1.tgz"
  sha256 "a5a7304466bbf8eb3c5360262df19a0543d711ee2df9f1ee268103c81cf47784"

  bottle do
    cellar :any_skip_relocation
    sha256 "41064500b6435fb2bfcfae9ed55b92a35710ac1a6a5f53485b11b917980e1b84" => :catalina
    sha256 "3d1969d30056ce5201e01843e64a2d0fbf8837d5239a4df7bbf8ff090bd8f35a" => :mojave
    sha256 "6683f35a659471def47cabb15311828745f2edc1c82350c8b7adc467f872c796" => :high_sierra
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
