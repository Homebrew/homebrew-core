class NodeSass < Formula
  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.103.0.tgz"
  sha256 "aa41b084177163ccd87a524ce810bee0e3e26b2d87980f3f0c489d9c3e7ed3b3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "758b154bdb3db7b464543b6cacd245b327cb122a6beee5f2c5035414540dc139"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "758b154bdb3db7b464543b6cacd245b327cb122a6beee5f2c5035414540dc139"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "758b154bdb3db7b464543b6cacd245b327cb122a6beee5f2c5035414540dc139"
    sha256 cellar: :any_skip_relocation, sonoma:        "5b38e1882883a1393472ce5f4cdaaa6c76f1e659ba99ec3b9f6d3df79861a4e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "73616b7e2a1f5ad817888ae310ac3fcc9a0704f7c4de73516afe69ad5af4d6e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "802270bca258b28b62bd5bcd87fb0c9e3624dfbb5daa03a061b58ea946e67083"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/"test.scss").write <<~SCSS
      div {
        img {
          border: 0px;
        }
      }
    SCSS

    assert_equal "div img{border:0px}",
    shell_output("#{bin}/sass --style=compressed test.scss").strip
  end
end
