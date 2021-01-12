class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.32.4.tgz"
  sha256 "0d0f1e35442cd829f3b05b282f231baee37b47958f7efcfcfb6077aafb852948"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "cc21c975b0844a0711d1cf154d3dbaed68e341072403f12bdea9c512edf6a9f8" => :big_sur
    sha256 "0aeafaf93647bfb285eb010dcea5b122974bf88ffef0a01684c008eefc673330" => :arm64_big_sur
    sha256 "c1355d6bfc1070c54a314988c47e92f4e27442cf1ea134487185501a1e3fdd27" => :catalina
    sha256 "bd9405cbbc94d8e5eda885e361dad5f6cc9db96e87459039cef3bf98fcc72ef0" => :mojave
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
