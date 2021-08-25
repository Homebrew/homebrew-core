class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.38.1.tgz"
  sha256 "fa6906cd3e394797ef00223e53b989d13c81ab7b764cbcbb6f600b1ba8048128"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "613ffa6e3d05c7a4fca8e7300eb35afd84b37e6a5cff383dac6462dafb2355ce"
    sha256 cellar: :any_skip_relocation, big_sur:       "613ffa6e3d05c7a4fca8e7300eb35afd84b37e6a5cff383dac6462dafb2355ce"
    sha256 cellar: :any_skip_relocation, catalina:      "613ffa6e3d05c7a4fca8e7300eb35afd84b37e6a5cff383dac6462dafb2355ce"
    sha256 cellar: :any_skip_relocation, mojave:        "613ffa6e3d05c7a4fca8e7300eb35afd84b37e6a5cff383dac6462dafb2355ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86811920c3c19899e07397762451657e392a5e2b2b0cc52540230c6f9929e9f3"
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
