class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.50.0.tgz"
  sha256 "f46e0208aaecfe15dd901437138727ca190ca031ae0ed786256a1d683d9acc37"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "645516e4e6046b127747d16c49f70dd62e76842b128ea3e3a107b3e6c721991e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "645516e4e6046b127747d16c49f70dd62e76842b128ea3e3a107b3e6c721991e"
    sha256 cellar: :any_skip_relocation, monterey:       "645516e4e6046b127747d16c49f70dd62e76842b128ea3e3a107b3e6c721991e"
    sha256 cellar: :any_skip_relocation, big_sur:        "645516e4e6046b127747d16c49f70dd62e76842b128ea3e3a107b3e6c721991e"
    sha256 cellar: :any_skip_relocation, catalina:       "645516e4e6046b127747d16c49f70dd62e76842b128ea3e3a107b3e6c721991e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e34500564c20e55453767276190cb874d4acf60a99706814161fbeb4049915c0"
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
