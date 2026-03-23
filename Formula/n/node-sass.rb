class NodeSass < Formula
  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.98.0.tgz"
  sha256 "0b14754e1b06b54f2f7cce57d3df1d9e742edae7974a74455e8c6b9675072dd6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "57e15d2df33809124ee660f4911f16a20c5ba6d73b4e97c03a747d505927a495"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "57e15d2df33809124ee660f4911f16a20c5ba6d73b4e97c03a747d505927a495"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "57e15d2df33809124ee660f4911f16a20c5ba6d73b4e97c03a747d505927a495"
    sha256 cellar: :any_skip_relocation, sonoma:        "734e6a986fa9d32cbd3b22005a38c023d5a365ff65afc2d1e6ab1b2d052ec280"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9df10b83e7f878645ed7d9c3d9ede7533611df0dd4dc8af8db95a3edcecade31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "913c7f688eb2a3857a2dc6845cccfde72aed750d6f375ffd964bcf5968dfd3fc"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
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
