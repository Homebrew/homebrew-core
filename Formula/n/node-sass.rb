class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.69.7.tgz"
  sha256 "809f9bd24d4f8c72b047561edd6fb33ad5a5d2c96bbf0e4f104fa5d1257ee534"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "622712fbdf0c2812f2b4728fa531e71c97203223369fc19c790037c592c0cc95"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "622712fbdf0c2812f2b4728fa531e71c97203223369fc19c790037c592c0cc95"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "622712fbdf0c2812f2b4728fa531e71c97203223369fc19c790037c592c0cc95"
    sha256 cellar: :any_skip_relocation, sonoma:         "622712fbdf0c2812f2b4728fa531e71c97203223369fc19c790037c592c0cc95"
    sha256 cellar: :any_skip_relocation, ventura:        "622712fbdf0c2812f2b4728fa531e71c97203223369fc19c790037c592c0cc95"
    sha256 cellar: :any_skip_relocation, monterey:       "622712fbdf0c2812f2b4728fa531e71c97203223369fc19c790037c592c0cc95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e75fae2e2868176509314ef1de32a2e965919afeec88da342605b73b7e56936b"
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
