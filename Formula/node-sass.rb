class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.32.0.tgz"
  sha256 "10cf6e249025883c917cba6a0cf95fe24783904818654ffd606b63a590443f16"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "9174afe265ef853edc7f8584f38e30cb0fc8e809faa08115ae134761a650fdec" => :big_sur
    sha256 "a97810fa76864ef70d04d93cb53ae6ad75ac606848ffd41694cb56ef09e85508" => :arm64_big_sur
    sha256 "17632419c069f504a0523a6aaaafe7b7875ce284942152311e8a8a6a894ca460" => :catalina
    sha256 "6c369a7ce201fe19dcc591e226ae749812b9717e74b36288ed094d0a8f906e59" => :mojave
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
