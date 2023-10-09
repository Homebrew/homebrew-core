class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.69.0.tgz"
  sha256 "9f647eefdec83ccb446275dcf13481f12f9aad43d08c506176186801a47c0891"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "92640b97a1bde6ffa6a318356ea842812fdc247b7d242837d81ccdbe881d7f25"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "92640b97a1bde6ffa6a318356ea842812fdc247b7d242837d81ccdbe881d7f25"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "92640b97a1bde6ffa6a318356ea842812fdc247b7d242837d81ccdbe881d7f25"
    sha256 cellar: :any_skip_relocation, sonoma:         "92640b97a1bde6ffa6a318356ea842812fdc247b7d242837d81ccdbe881d7f25"
    sha256 cellar: :any_skip_relocation, ventura:        "92640b97a1bde6ffa6a318356ea842812fdc247b7d242837d81ccdbe881d7f25"
    sha256 cellar: :any_skip_relocation, monterey:       "92640b97a1bde6ffa6a318356ea842812fdc247b7d242837d81ccdbe881d7f25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0954d8da66a1efe568d96227be353c498be4e28ca02dade513875f850ff2d5ec"
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
