class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.54.3.tgz"
  sha256 "ea47c030e9dda5818179b2beaaf00005c61b7e7876cdd704b56bd662cf5d231e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e182a37d2f6b79ead9166cea221deeb7cc12c16ba28ad7a57598ec3952f2439"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9e182a37d2f6b79ead9166cea221deeb7cc12c16ba28ad7a57598ec3952f2439"
    sha256 cellar: :any_skip_relocation, monterey:       "9e182a37d2f6b79ead9166cea221deeb7cc12c16ba28ad7a57598ec3952f2439"
    sha256 cellar: :any_skip_relocation, big_sur:        "9e182a37d2f6b79ead9166cea221deeb7cc12c16ba28ad7a57598ec3952f2439"
    sha256 cellar: :any_skip_relocation, catalina:       "9e182a37d2f6b79ead9166cea221deeb7cc12c16ba28ad7a57598ec3952f2439"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "162aa3f0c50a54e638aef770e379cb637c2b0580a2441e14dbbbab183ba8e566"
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
