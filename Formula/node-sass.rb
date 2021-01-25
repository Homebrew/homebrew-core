class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.32.5.tgz"
  sha256 "6132cc4a4f6c85f36c7333a5f4c64fe5e482f494ef61da0fde0cbe415d0d6c85"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "b4bce85415f0aca26a255dffc7f0a00a64426a34e692506f03a71979a04291d7" => :big_sur
    sha256 "60f627515dbf2a989b65b3d34acb3f42ee32f1a2c3de08068d78de11dc206d65" => :arm64_big_sur
    sha256 "2c118df451fd954b260ba60c889797b6e5372a45ff1b67698b045ab67ec9e139" => :catalina
    sha256 "a611612e2017fbc825e2aef6ea7951bc8caf0411d4f2165618ae21aaabddcdd1" => :mojave
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
