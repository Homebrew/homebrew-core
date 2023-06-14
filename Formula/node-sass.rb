class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.63.4.tgz"
  sha256 "5902a8ab743320f9edc1b304021df283cdb4e9edab1f3b81282bf446743c58be"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8fb03e6f457ed5ff08bca641d44d1b5c4f617c48b431fa173b164cf554111567"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8fb03e6f457ed5ff08bca641d44d1b5c4f617c48b431fa173b164cf554111567"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8fb03e6f457ed5ff08bca641d44d1b5c4f617c48b431fa173b164cf554111567"
    sha256 cellar: :any_skip_relocation, ventura:        "8fb03e6f457ed5ff08bca641d44d1b5c4f617c48b431fa173b164cf554111567"
    sha256 cellar: :any_skip_relocation, monterey:       "8fb03e6f457ed5ff08bca641d44d1b5c4f617c48b431fa173b164cf554111567"
    sha256 cellar: :any_skip_relocation, big_sur:        "8fb03e6f457ed5ff08bca641d44d1b5c4f617c48b431fa173b164cf554111567"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09ab7b72f6381a38e2ca58756ffd06641c3245373b0f7a1a450a7762db4fa92f"
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
