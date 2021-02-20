class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.32.8.tgz"
  sha256 "3660d5b0b8f93b9c6baed87d24b4533cc44c21554b303af83c865c68f983a6ba"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "20d0865456da38121799ae943aa1f4c457ebe205195a6236f28531e3d4c173dd"
    sha256 cellar: :any_skip_relocation, big_sur:       "944b0e428a830f4fda5f07da2dfbbebd8f32759c13f812554c97b31c7a9ef09a"
    sha256 cellar: :any_skip_relocation, catalina:      "6a24e91e010142cef27b15c500bdb0b3f474cb0255372d999a04803e13b2ffdd"
    sha256 cellar: :any_skip_relocation, mojave:        "68ad962cc9633875b77685c844bae2f5ee25c155c20ece05529dadb788c04e8d"
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
