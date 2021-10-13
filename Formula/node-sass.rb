class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.43.2.tgz"
  sha256 "aab045392c0ee9b45bb439479035c80d438de305609197f6ce3edc7567a457aa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "24a0200beb4ef26c79dc92289559afc5f62bed3e9f54569a8fb9512b7e7393b9"
    sha256 cellar: :any_skip_relocation, big_sur:       "24a0200beb4ef26c79dc92289559afc5f62bed3e9f54569a8fb9512b7e7393b9"
    sha256 cellar: :any_skip_relocation, catalina:      "24a0200beb4ef26c79dc92289559afc5f62bed3e9f54569a8fb9512b7e7393b9"
    sha256 cellar: :any_skip_relocation, mojave:        "24a0200beb4ef26c79dc92289559afc5f62bed3e9f54569a8fb9512b7e7393b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "256e15b6e49652e37b966a4028790305a3a9297c172ca750019bb769ebb54f14"
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
