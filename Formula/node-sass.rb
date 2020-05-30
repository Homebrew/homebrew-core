class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.26.7.tgz"
  sha256 "9292dc31cb65b88bb732e94bf8f534e14df2d8a190127eada848d4e85a0b6f77"

  bottle do
    cellar :any_skip_relocation
    sha256 "6502fb14be008a853a169e87f9e5eafe9a8ec7fd2eddbb6a968ae2e431689c79" => :catalina
    sha256 "be9030689da502229de35b479b8bca94f5b4a27d3656c6d90a3bcf15f8029eb2" => :mojave
    sha256 "b369e45d35e36e760243bfaa3679b81f60ddd3cdc599ca2f976fc2b47fd55e17" => :high_sierra
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
