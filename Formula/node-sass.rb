class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.54.5.tgz"
  sha256 "b772ef2acccd3325a847bd4efb1020ae6b4ba92433b1e57171e13c95f72dee9a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c444b6b9931799d8fa1bbe1c1346c3ac988c54179009cdc573461b6658f87688"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c444b6b9931799d8fa1bbe1c1346c3ac988c54179009cdc573461b6658f87688"
    sha256 cellar: :any_skip_relocation, monterey:       "c444b6b9931799d8fa1bbe1c1346c3ac988c54179009cdc573461b6658f87688"
    sha256 cellar: :any_skip_relocation, big_sur:        "c444b6b9931799d8fa1bbe1c1346c3ac988c54179009cdc573461b6658f87688"
    sha256 cellar: :any_skip_relocation, catalina:       "c444b6b9931799d8fa1bbe1c1346c3ac988c54179009cdc573461b6658f87688"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "446759c9fded83d8d946cf4869aacd9201109582a90907b64802d28419552cc4"
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
