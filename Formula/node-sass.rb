class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.32.6.tgz"
  sha256 "226607d399eb66642ec3a94b593aaf540913f87b6a9ec15a991af04e7ee40286"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "28f61babd03feda0d39d66a5801d76123bd67e28feec6df95e10f2c739690af3"
    sha256 cellar: :any_skip_relocation, big_sur:       "5891229fce7328eb619b57b8ca4c04430159a1491b824a9ee427387ea599e6b4"
    sha256 cellar: :any_skip_relocation, catalina:      "11a7d824ad2bbbf9800e20ef7755f009b7e68ee823975fe37e325b1f85bb7a42"
    sha256 cellar: :any_skip_relocation, mojave:        "31b5ea620e157eb11db0f86aac65deb2ed055a4be0def6cf1a627f51fe884c77"
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
