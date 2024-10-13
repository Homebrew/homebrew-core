class JsBeautify < Formula
  desc "JavaScript, CSS and HTML unobfuscator and beautifier"
  homepage "https://beautifier.io"
  url "https://registry.npmjs.org/js-beautify/-/js-beautify-1.15.1.tgz"
  sha256 "b840f39d9e8c41a54909f299e1850c254ed33cdefc2d983726ee1f607506a36b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "68d8c474b3c6b0685b296bb72eac5e1975bd42bc6ad75b14cd37ec88503aa2ae"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "479ed5ae5125c2fd803c0552ff833a0f13be1da2f5220877319c32695d7461e3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "479ed5ae5125c2fd803c0552ff833a0f13be1da2f5220877319c32695d7461e3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "479ed5ae5125c2fd803c0552ff833a0f13be1da2f5220877319c32695d7461e3"
    sha256 cellar: :any_skip_relocation, sonoma:         "6941f619f219475be60ffe4313eedeb89b6f917ed192f20de30be34071be682e"
    sha256 cellar: :any_skip_relocation, ventura:        "6941f619f219475be60ffe4313eedeb89b6f917ed192f20de30be34071be682e"
    sha256 cellar: :any_skip_relocation, monterey:       "6941f619f219475be60ffe4313eedeb89b6f917ed192f20de30be34071be682e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "479ed5ae5125c2fd803c0552ff833a0f13be1da2f5220877319c32695d7461e3"
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
