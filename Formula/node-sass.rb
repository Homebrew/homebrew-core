class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.26.2.tgz"
  sha256 "a262f2fe4c6aab9a4ff7fa458c09a6797e09e208b2e0f9aed88742455a5a1bf4"

  bottle do
    cellar :any_skip_relocation
    sha256 "0f56dcd061453bad57aa438499db321e0d1535d6dfa555a1073178fad6fbdbe0" => :catalina
    sha256 "d96e8d23c1c86bac5628d4b6198d9bbca258982de50c5c57778435587bf36425" => :mojave
    sha256 "0366aa4e52543fb4f897bf194171961c31920fbe90cb9064ee572829b66c931b" => :high_sierra
  end

  depends_on "node"

  # waiting for pull request at #47438
  # conflicts_with "dart-sass", :because => "both install a `sass` binary"

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
