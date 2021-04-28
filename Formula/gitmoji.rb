require "language/node"

class Gitmoji < Formula
  desc "Emoji guide for your commit messages"
  homepage "https://gitmoji.carloscuesta.me"
  url "https://registry.npmjs.org/gitmoji-cli/-/gitmoji-cli-4.0.0.tgz"
  sha256 "5cd9e273533c90f22c867d23390bca48481acb626b08ed5b64721907eb3e8af6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1cbc7a8c2d66c913b160ad3657cd86ec7791ab22d03fc3362e717d0efe19521f"
    sha256 cellar: :any_skip_relocation, big_sur:       "7a5fcce1c1b0b10923a643bfb4ef454aa4fc0958847804018ef93396030f8b25"
    sha256 cellar: :any_skip_relocation, catalina:      "7a5fcce1c1b0b10923a643bfb4ef454aa4fc0958847804018ef93396030f8b25"
    sha256 cellar: :any_skip_relocation, mojave:        "7a5fcce1c1b0b10923a643bfb4ef454aa4fc0958847804018ef93396030f8b25"
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
