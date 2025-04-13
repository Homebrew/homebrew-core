class NodeSass < Formula
  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.86.3.tgz"
  sha256 "34f7312e6a151b7dae8c1de5952d4a00b2cc5cb77c2abba44f996b36343ff9ec"
  license "MIT"

  bottle do
    sha256                               arm64_sequoia: "8fe3599d275d343b4a33e82ea3716a1925623bcb67afa879c9c9f67ea6ea4ea9"
    sha256                               arm64_sonoma:  "4507ce4991b8e52589c1da322bef01920f3317fef4c73d9c0a4b3d5c0b694618"
    sha256                               arm64_ventura: "06b0cfd6d7e534fa97b7cf46b13a4155ab47dde7fd3c38987e59ffbb0d3a3d89"
    sha256                               sonoma:        "748a44fd719897613197e739cf1281b7b1faf34645b904c552156c3de155c814"
    sha256                               ventura:       "473cdf5daecc62c282e048eba25ec61f4674ea276f187c729d66cd37d5f591d3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2483a4d1b4136e2dbb2c1b36c863a6d462de287fe20780f717b73677d02548cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f143e6dce903411663f7c637d09280ee2a270f48f0288929b7429fd0f61e94b1"
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
