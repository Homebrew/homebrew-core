class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.60.0.tgz"
  sha256 "dc3e121be72a6b3c47f4c3eb3c83c631c1a8f0e0d9d161ae68084d823e417123"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a9d09db9b84b46cc3f55df8d6c53e319426d357490ff2902a20e4ce12a466e09"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a9d09db9b84b46cc3f55df8d6c53e319426d357490ff2902a20e4ce12a466e09"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a9d09db9b84b46cc3f55df8d6c53e319426d357490ff2902a20e4ce12a466e09"
    sha256 cellar: :any_skip_relocation, ventura:        "a9d09db9b84b46cc3f55df8d6c53e319426d357490ff2902a20e4ce12a466e09"
    sha256 cellar: :any_skip_relocation, monterey:       "a9d09db9b84b46cc3f55df8d6c53e319426d357490ff2902a20e4ce12a466e09"
    sha256 cellar: :any_skip_relocation, big_sur:        "a9d09db9b84b46cc3f55df8d6c53e319426d357490ff2902a20e4ce12a466e09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a0a2b381dfba749f3cfe6f8f39419a69a53b4ae9395994c2c3c58d4c3ff715a"
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
