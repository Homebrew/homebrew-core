class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.43.4.tgz"
  sha256 "1e6cf50db84f378feecc590bffd10ee2cd3489b26226caa63b26948dc9c45c56"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ee48b5edee5734eb59f43a8f09766ec14a6dd65c5d16b2348cf543ff8144825e"
    sha256 cellar: :any_skip_relocation, big_sur:       "ee48b5edee5734eb59f43a8f09766ec14a6dd65c5d16b2348cf543ff8144825e"
    sha256 cellar: :any_skip_relocation, catalina:      "ee48b5edee5734eb59f43a8f09766ec14a6dd65c5d16b2348cf543ff8144825e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e3e607d386cfdb17210362e9777c87269974119efc51bd6583d84eefcb60dca"
    sha256 cellar: :any_skip_relocation, all:           "ee48b5edee5734eb59f43a8f09766ec14a6dd65c5d16b2348cf543ff8144825e"
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
