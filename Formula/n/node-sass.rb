class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.72.0.tgz"
  sha256 "0c3ab88974823e8cec1217d956a87b8b7e94980bf6dc7773b1f3936e45536d16"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ebe6fdbbea777c2d4c11033d77adc7eb14fbc7d914d1ac888f5c018b00fa5392"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ebe6fdbbea777c2d4c11033d77adc7eb14fbc7d914d1ac888f5c018b00fa5392"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ebe6fdbbea777c2d4c11033d77adc7eb14fbc7d914d1ac888f5c018b00fa5392"
    sha256 cellar: :any_skip_relocation, sonoma:         "ebe6fdbbea777c2d4c11033d77adc7eb14fbc7d914d1ac888f5c018b00fa5392"
    sha256 cellar: :any_skip_relocation, ventura:        "ebe6fdbbea777c2d4c11033d77adc7eb14fbc7d914d1ac888f5c018b00fa5392"
    sha256 cellar: :any_skip_relocation, monterey:       "ebe6fdbbea777c2d4c11033d77adc7eb14fbc7d914d1ac888f5c018b00fa5392"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "323df46e67dca533a5164cacd24fc6aa0dbe828e1158cea0a535c9328df28940"
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
