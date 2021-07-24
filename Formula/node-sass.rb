class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.36.0.tgz"
  sha256 "316fde0353ced2fee300472d6c98ec148613261bb3ffe27dcfd4b1fb5112e2b2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "29a0eddfb2124e8a1d017dfa65199cf90cc6007727aac2462bb28618a3fe5692"
    sha256 cellar: :any_skip_relocation, all:          "a092fc458b3c6759fd3a5f140e6d9e9e732cce3c0c4f658a0057f520854ea06c"
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
