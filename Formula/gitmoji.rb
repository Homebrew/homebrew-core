require "language/node"

class Gitmoji < Formula
  desc "Emoji guide for your commit messages"
  homepage "https://gitmoji.carloscuesta.me"
  url "https://registry.npmjs.org/gitmoji-cli/-/gitmoji-cli-3.2.10.tgz"
  sha256 "1c95ffe5c96f8dcba4fc45f10d4cec4e8b737889708644f07b43deaf4719ef6b"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "70819fb36259fd05cefadbf804cbc56dc54363a4ffb852acab17a43002bd2c71" => :catalina
    sha256 "49953c56e21686080e2d4a531aad981f3288893f4a733421fada8b60d82ad4fd" => :mojave
    sha256 "a1c859523ccd0c6432cd94777db4bd7430904dbdf83f96ec36bd76eb0f5f9504" => :high_sierra
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
