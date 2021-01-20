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
    sha256 "3b7676dcd90c3bd7daf080f793fade150aded0f4c05a2e31ecc3c6d1f66da757" => :big_sur
    sha256 "35ff179b97414b610eb7b45b155248199c25f1b3b49176e9bdbbef73bb9562f4" => :arm64_big_sur
    sha256 "9cec2d6c5036b5c771921c87e13373f26873be91d9c04bbcdeedac25c8cb9f86" => :catalina
    sha256 "7cbbd382e9c9ebf89656bdb82f3057fa85eaaecae1f59eda221068fe5d3ca895" => :mojave
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
