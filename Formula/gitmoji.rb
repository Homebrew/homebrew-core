require "language/node"

class Gitmoji < Formula
  desc "Emoji guide for your commit messages"
  homepage "https://gitmoji.carloscuesta.me"
  url "https://registry.npmjs.org/gitmoji-cli/-/gitmoji-cli-4.4.1.tgz"
  sha256 "ad2dcf00b4bb6a974e9157ad1b5438b118cb6b3a523f9d6400a4dc137ca630e5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "df227f0b8dbad71adf742ca8d8e845d262a3122e44c12173f380b1ffb1346c7b"
    sha256 cellar: :any_skip_relocation, big_sur:       "8ed6071838adec45ff399a29c5d1bcfc08954ebae54d1303ff0eb3e73ed2ed00"
    sha256 cellar: :any_skip_relocation, catalina:      "8ed6071838adec45ff399a29c5d1bcfc08954ebae54d1303ff0eb3e73ed2ed00"
    sha256 cellar: :any_skip_relocation, mojave:        "8ed6071838adec45ff399a29c5d1bcfc08954ebae54d1303ff0eb3e73ed2ed00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df227f0b8dbad71adf742ca8d8e845d262a3122e44c12173f380b1ffb1346c7b"
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
