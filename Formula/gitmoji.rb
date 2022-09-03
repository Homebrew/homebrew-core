require "language/node"

class Gitmoji < Formula
  desc "Interactive command-line tool for using emoji in commit messages"
  homepage "https://gitmoji.dev"
  url "https://registry.npmjs.org/gitmoji-cli/-/gitmoji-cli-6.2.0.tgz"
  sha256 "4a2909f78f6bab6615b37878a2c827232e89568916d9140bbebf12c34746a366"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d1c67b635d4d2f786898b625cb79012aae7fb8ccb33761d54695294f49e6bc38"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d1c67b635d4d2f786898b625cb79012aae7fb8ccb33761d54695294f49e6bc38"
    sha256 cellar: :any_skip_relocation, monterey:       "75d99fc2be12612e51f496cb55d1c25c0964cd5e739b43efc5e1f3b33ffd1644"
    sha256 cellar: :any_skip_relocation, big_sur:        "75d99fc2be12612e51f496cb55d1c25c0964cd5e739b43efc5e1f3b33ffd1644"
    sha256 cellar: :any_skip_relocation, catalina:       "75d99fc2be12612e51f496cb55d1c25c0964cd5e739b43efc5e1f3b33ffd1644"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d1c67b635d4d2f786898b625cb79012aae7fb8ccb33761d54695294f49e6bc38"
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
