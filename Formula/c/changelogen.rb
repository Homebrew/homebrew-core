class Changelogen < Formula
  desc "Generate Beautiful Changelogs using Conventional Commits"
  homepage "https://github.com/unjs/changelogen"
  url "https://registry.npmjs.org/changelogen/-/changelogen-0.6.2.tgz"
  sha256 "cd5e783f11a9496293d2c7790e36574981296192849a9d904dec617e65e257b2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8f81b6116ef1eb1212acc82b881c4bd1c099d9a3221c76ea12203be07f73f2a9"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "git", "init"
    touch "test"
    system "git", "add", "test"
    system "git", "commit", "-m", "feat: initial commit"
    assert_match "Generating changelog", shell_output("#{bin}/changelogen 2>&1")
  end
end
