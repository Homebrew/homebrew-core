class NodeSass < Formula
  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.89.2.tgz"
  sha256 "544ff289e63002671a2a782e52619040fdf001ed3878b0b20b567cd1a09cf98b"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "ca237a855d49e43221fa1b6d7aa40864284aef701e3329c919b5842c9ada1908"
    sha256                               arm64_sonoma:  "ff061889cb947f5fb9f84cea73fbf96995474fe9ed4dd577a428ab5e4a9576ab"
    sha256                               arm64_ventura: "6a8fd3054cbbc19409776877648073c9c2d72a7f1f14c07d3bb98924f6d16df2"
    sha256                               sonoma:        "d0ee88d76110fdf2728a9dfb2dd17bd2bf426c5486164d208d04daaf3e76f2a9"
    sha256                               ventura:       "b8e7789b7dea5c7d890299940a70271e8d319f96318825877f2abb0d18a90ae7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "649e4cfb63dedbd0518569f89524dde2b43ae454c11e8fe31a32564de06d8b39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5215a36b5b01f0c3bed4770242f5225edf3da02b7efb805e5832ed3eaf4b08e2"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
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
