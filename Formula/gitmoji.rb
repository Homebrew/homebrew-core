require "language/node"

class Gitmoji < Formula
  desc "Interactive command-line tool for using emoji in commit messages"
  homepage "https://gitmoji.dev"
  url "https://registry.npmjs.org/gitmoji-cli/-/gitmoji-cli-4.7.0.tgz"
  sha256 "ec602331cef124b9b3064b4291e01370048eb703ffda26dc5f399d894d4232a8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "33877fad24b1ca32539f500fe3bd35fa26cc9c92aa78fba352a01082c435f493"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8bcb44e8427347f0c761adb99eaca5344fc886dfc288a51098a21277aa96f3d5"
    sha256 cellar: :any_skip_relocation, monterey:       "ab0221dc3571e720f5b1a376b8d415fdaeafe0ff54c9a9abfaa53587aae7c1b0"
    sha256 cellar: :any_skip_relocation, big_sur:        "07195afc3abf49df75264de636d55ec69b6aa305a03e41c30a435fe366779d61"
    sha256 cellar: :any_skip_relocation, catalina:       "07195afc3abf49df75264de636d55ec69b6aa305a03e41c30a435fe366779d61"
    sha256 cellar: :any_skip_relocation, mojave:         "07195afc3abf49df75264de636d55ec69b6aa305a03e41c30a435fe366779d61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8bcb44e8427347f0c761adb99eaca5344fc886dfc288a51098a21277aa96f3d5"
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
