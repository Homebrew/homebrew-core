class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.37.2.tgz"
  sha256 "76fd2d360fbef78dc81986dc5d193fac31e21deb6bd05dc8f5cb53250b0b0d4e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0f9cfc14e951d88b622fac4f90ebae185af4d513e8e4c1f4323710de7c7de65b"
    sha256 cellar: :any_skip_relocation, big_sur:       "0f9cfc14e951d88b622fac4f90ebae185af4d513e8e4c1f4323710de7c7de65b"
    sha256 cellar: :any_skip_relocation, catalina:      "0f9cfc14e951d88b622fac4f90ebae185af4d513e8e4c1f4323710de7c7de65b"
    sha256 cellar: :any_skip_relocation, mojave:        "0f9cfc14e951d88b622fac4f90ebae185af4d513e8e4c1f4323710de7c7de65b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f56b553c5e15e47b1fae4e5cdad65a75dcfade8ff5385c6b4b678bbde462591"
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
