class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.32.10.tgz"
  sha256 "28a55fb73313df27f0f48cece8a4cb795ce471439b701dbac61d34b47e8f2c09"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4b718fb39c3ee21e39da390239c2e9cba9e637277b376a26a3615c7810ad08ce"
    sha256 cellar: :any_skip_relocation, big_sur:       "218e0e4bcec8520ba13c479804fba2ff296411b34d9376b570d8c4e8593c38ca"
    sha256 cellar: :any_skip_relocation, catalina:      "218e0e4bcec8520ba13c479804fba2ff296411b34d9376b570d8c4e8593c38ca"
    sha256 cellar: :any_skip_relocation, mojave:        "68f8e6548ed2a68a73a6ba54615c3f649783c3435a12c7ed575f0f4ea39149a0"
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
