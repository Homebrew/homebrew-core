class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.56.1.tgz"
  sha256 "ed6928f3fd1b279bff10fbda12bf49c817d322b7072d8c36a82b8f5fdf07cce1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b8cf282e40effcd3a5978b915385606fe305539326b1ee88e65ced62f2150efb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b8cf282e40effcd3a5978b915385606fe305539326b1ee88e65ced62f2150efb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b8cf282e40effcd3a5978b915385606fe305539326b1ee88e65ced62f2150efb"
    sha256 cellar: :any_skip_relocation, monterey:       "b8cf282e40effcd3a5978b915385606fe305539326b1ee88e65ced62f2150efb"
    sha256 cellar: :any_skip_relocation, big_sur:        "b8cf282e40effcd3a5978b915385606fe305539326b1ee88e65ced62f2150efb"
    sha256 cellar: :any_skip_relocation, catalina:       "b8cf282e40effcd3a5978b915385606fe305539326b1ee88e65ced62f2150efb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b03b48236cacc53b69f4fca670f2732702cc264bf852e47262eccc70921cc70a"
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
