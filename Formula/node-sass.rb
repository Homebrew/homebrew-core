class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.43.4.tgz"
  sha256 "1e6cf50db84f378feecc590bffd10ee2cd3489b26226caa63b26948dc9c45c56"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "790d2b517b8423bbe4e0bbf7fa8f6bb006145005f87478d4262dc55ab96a13a7"
    sha256 cellar: :any_skip_relocation, big_sur:       "790d2b517b8423bbe4e0bbf7fa8f6bb006145005f87478d4262dc55ab96a13a7"
    sha256 cellar: :any_skip_relocation, catalina:      "790d2b517b8423bbe4e0bbf7fa8f6bb006145005f87478d4262dc55ab96a13a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f9713f78f0a705bde460d7d1e559b4d2d04a042981e571d76df44ce53ebfa321"
    sha256 cellar: :any_skip_relocation, all:           "790d2b517b8423bbe4e0bbf7fa8f6bb006145005f87478d4262dc55ab96a13a7"
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
