class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.56.2.tgz"
  sha256 "c6c6fe46c1988482cd981fbaf01fac5288d449124d6e1ad8e4ac11d21a80aab6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "334c1a2b11bbe06b208d1f38ee554830eeaa61d186f660036a49adb68d7c1615"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "334c1a2b11bbe06b208d1f38ee554830eeaa61d186f660036a49adb68d7c1615"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "334c1a2b11bbe06b208d1f38ee554830eeaa61d186f660036a49adb68d7c1615"
    sha256 cellar: :any_skip_relocation, ventura:        "334c1a2b11bbe06b208d1f38ee554830eeaa61d186f660036a49adb68d7c1615"
    sha256 cellar: :any_skip_relocation, monterey:       "334c1a2b11bbe06b208d1f38ee554830eeaa61d186f660036a49adb68d7c1615"
    sha256 cellar: :any_skip_relocation, big_sur:        "334c1a2b11bbe06b208d1f38ee554830eeaa61d186f660036a49adb68d7c1615"
    sha256 cellar: :any_skip_relocation, catalina:       "334c1a2b11bbe06b208d1f38ee554830eeaa61d186f660036a49adb68d7c1615"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "255ca664661a7cf79598f2e177681957d8c3f24285c910f8a269a95afc3374be"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.scss").write <<~EOS
      div {
        img {
          border: 0px;
        }
      }
    EOS

    assert_equal "div img{border:0px}",
    shell_output("#{bin}/sass --style=compressed test.scss").strip
  end
end
