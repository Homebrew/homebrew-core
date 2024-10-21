class NodeSass < Formula
  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.80.3.tgz"
  sha256 "34603949cfae96a8cc846c4cd910871d430e3dee08ceebfb0c36888637d81c89"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "438078471dc191fedd23f444d07b539a033a0e7b11a5700f248407b256a9f0fa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "438078471dc191fedd23f444d07b539a033a0e7b11a5700f248407b256a9f0fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "438078471dc191fedd23f444d07b539a033a0e7b11a5700f248407b256a9f0fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "3ce2c3d62fe181f90286b0047c482431f1014e6efc3e0c16e497023c4b7964a4"
    sha256 cellar: :any_skip_relocation, ventura:       "3ce2c3d62fe181f90286b0047c482431f1014e6efc3e0c16e497023c4b7964a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90b14243cbdf8246c5d4a977eb39835bc589a821a2cb538cb2e73d949b74dc2e"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
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
