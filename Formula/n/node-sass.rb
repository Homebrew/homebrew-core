class NodeSass < Formula
  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.77.8.tgz"
  sha256 "27d467af0797116c5ecf21503bcfb4bed270724306846ea4fde360281f87af7b"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "280da51d69a7d433152ff206a85ff2829aaf77ddbd2f505f06e69436746eceee"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "280da51d69a7d433152ff206a85ff2829aaf77ddbd2f505f06e69436746eceee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "280da51d69a7d433152ff206a85ff2829aaf77ddbd2f505f06e69436746eceee"
    sha256 cellar: :any_skip_relocation, sonoma:         "280da51d69a7d433152ff206a85ff2829aaf77ddbd2f505f06e69436746eceee"
    sha256 cellar: :any_skip_relocation, ventura:        "280da51d69a7d433152ff206a85ff2829aaf77ddbd2f505f06e69436746eceee"
    sha256 cellar: :any_skip_relocation, monterey:       "280da51d69a7d433152ff206a85ff2829aaf77ddbd2f505f06e69436746eceee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe1232a504ef5c1f1603c4d1aff16fdf1770cdd432d1a65b0ffab8baf2cb55ea"
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
