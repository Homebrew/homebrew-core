class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.69.4.tgz"
  sha256 "ce91baadd5f9b0dda64ab97f76d34755ef20d37fbf5567ba0996b63bc4851579"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9985861e06afa8993b7f9474c206b5c709f9ceae0589a7bae06c8ff89ad5a39c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9985861e06afa8993b7f9474c206b5c709f9ceae0589a7bae06c8ff89ad5a39c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9985861e06afa8993b7f9474c206b5c709f9ceae0589a7bae06c8ff89ad5a39c"
    sha256 cellar: :any_skip_relocation, sonoma:         "9985861e06afa8993b7f9474c206b5c709f9ceae0589a7bae06c8ff89ad5a39c"
    sha256 cellar: :any_skip_relocation, ventura:        "9985861e06afa8993b7f9474c206b5c709f9ceae0589a7bae06c8ff89ad5a39c"
    sha256 cellar: :any_skip_relocation, monterey:       "9985861e06afa8993b7f9474c206b5c709f9ceae0589a7bae06c8ff89ad5a39c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6db7aa70660bcaeed2167b2c631f9f4ece1767256789ba54c5733a5c8cebf807"
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
