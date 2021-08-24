class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.38.1.tgz"
  sha256 "fa6906cd3e394797ef00223e53b989d13c81ab7b764cbcbb6f600b1ba8048128"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c75bb6ab619fb8462ceb149fa7bb79538e1b7b30a90766b1f35e6ad17a7c8e3b"
    sha256 cellar: :any_skip_relocation, big_sur:       "c75bb6ab619fb8462ceb149fa7bb79538e1b7b30a90766b1f35e6ad17a7c8e3b"
    sha256 cellar: :any_skip_relocation, catalina:      "c75bb6ab619fb8462ceb149fa7bb79538e1b7b30a90766b1f35e6ad17a7c8e3b"
    sha256 cellar: :any_skip_relocation, mojave:        "c75bb6ab619fb8462ceb149fa7bb79538e1b7b30a90766b1f35e6ad17a7c8e3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d4f076bbdf5ec1da285679f3e12ff6d5a6e972e9412e626af4a60bcc180c931"
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
