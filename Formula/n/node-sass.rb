class NodeSass < Formula
  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.104.0.tgz"
  sha256 "38d27c532071b573b75498ca7ef61738d769f40a8ad6f8564cca28334473bba7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6e22fbe67e262bce74ee673fc305f5b000330af31c5d6cec95dd61ef7fac1a8f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e22fbe67e262bce74ee673fc305f5b000330af31c5d6cec95dd61ef7fac1a8f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e22fbe67e262bce74ee673fc305f5b000330af31c5d6cec95dd61ef7fac1a8f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "15aae503f4119f211962110c7abdf3cf7291dda6db959e77450113e0dc5c07c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5bbb8b39f4084040fe150017333326429ae66b621754eb25a67149865137e86"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/"test.scss").write <<~SCSS
      div {
        img {
          border: 0px;
        }
      }
    SCSS

    assert_equal "div img{border:0px}",
    shell_output("#{bin}/sass --style=compressed test.scss").strip
  end
end
