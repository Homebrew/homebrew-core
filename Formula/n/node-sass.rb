class NodeSass < Formula
  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.99.0.tgz"
  sha256 "840e556f3c47f6dd862733872364698c2355952e8cb6d55e6416032dfe2dcb26"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e158e50a3851ffc29d73f1dd168884a89dedd72fa0a4f10d117044229865a68b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e158e50a3851ffc29d73f1dd168884a89dedd72fa0a4f10d117044229865a68b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e158e50a3851ffc29d73f1dd168884a89dedd72fa0a4f10d117044229865a68b"
    sha256 cellar: :any_skip_relocation, sonoma:        "c48a966a91cbebc6be50e1ca00c7705bf0508efad903f3bebc28664220f2eadc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e52a14043ca160795894eb7c1477fb005aaebbf619c477ce87f5b4bf0ddae00b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "79749ba42766dcd1253d89f2261162cff1e1e528ea005372af725900e51ae221"
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
