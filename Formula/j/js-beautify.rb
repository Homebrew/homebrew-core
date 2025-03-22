class JsBeautify < Formula
  desc "JavaScript, CSS and HTML unobfuscator and beautifier"
  homepage "https://beautifier.io"
  url "https://registry.npmjs.org/js-beautify/-/js-beautify-1.15.4.tgz"
  sha256 "5feefb437c9467e789d179fc4cbc4f942008c05222f6b573a4f03ee41e31d9a6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c7e52487e23c2cd2674a6cc83610b8509209489fc632b86f69f936bc596aafd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c7e52487e23c2cd2674a6cc83610b8509209489fc632b86f69f936bc596aafd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7c7e52487e23c2cd2674a6cc83610b8509209489fc632b86f69f936bc596aafd"
    sha256 cellar: :any_skip_relocation, sonoma:        "21cbc33bb8e2b885663dfcc5bd5219dd571ea648ac5ad4b29833b45951824c78"
    sha256 cellar: :any_skip_relocation, ventura:       "21cbc33bb8e2b885663dfcc5bd5219dd571ea648ac5ad4b29833b45951824c78"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c7e52487e23c2cd2674a6cc83610b8509209489fc632b86f69f936bc596aafd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c7e52487e23c2cd2674a6cc83610b8509209489fc632b86f69f936bc596aafd"
  end

  depends_on "node"

  conflicts_with "jsbeautifier", because: "both install `js-beautify` binaries"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    javascript = "if ('this_is'==/an_example/){of_beautifier();}else{var a=b?(c%d):e[f];}"
    assert_equal <<~EOS.chomp, pipe_output(bin/"js-beautify", javascript)
      if ('this_is' == /an_example/) {
          of_beautifier();
      } else {
          var a = b ? (c % d) : e[f];
      }
    EOS
  end
end
