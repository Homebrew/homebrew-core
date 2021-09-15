class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.41.0.tgz"
  sha256 "0cbbc711545ad45de09e9cd3f9454adf8ecd81024db654fb348ddfd5d5f96ee8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9ee20dfedb09f9d5477a669865bae29b05a91d42d8a9dcb080265bae72afa2ec"
    sha256 cellar: :any_skip_relocation, big_sur:       "9ee20dfedb09f9d5477a669865bae29b05a91d42d8a9dcb080265bae72afa2ec"
    sha256 cellar: :any_skip_relocation, catalina:      "9ee20dfedb09f9d5477a669865bae29b05a91d42d8a9dcb080265bae72afa2ec"
    sha256 cellar: :any_skip_relocation, mojave:        "9ee20dfedb09f9d5477a669865bae29b05a91d42d8a9dcb080265bae72afa2ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aec99f0e3289b2d1c6952c2b397631322fcfd78f607fbac66eeca7ecb34062ea"
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
