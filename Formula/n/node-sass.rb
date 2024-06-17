class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.77.5.tgz"
  sha256 "58613b1270df073161680c2382aa5e8930ccd129357c7c27321a7ecbd1501667"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6cd21192750835acdb39dfc5b2cebc8d68d35ffdfe466e671fef2bc5fd02f42c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6cd21192750835acdb39dfc5b2cebc8d68d35ffdfe466e671fef2bc5fd02f42c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6cd21192750835acdb39dfc5b2cebc8d68d35ffdfe466e671fef2bc5fd02f42c"
    sha256 cellar: :any_skip_relocation, sonoma:         "6cd21192750835acdb39dfc5b2cebc8d68d35ffdfe466e671fef2bc5fd02f42c"
    sha256 cellar: :any_skip_relocation, ventura:        "6cd21192750835acdb39dfc5b2cebc8d68d35ffdfe466e671fef2bc5fd02f42c"
    sha256 cellar: :any_skip_relocation, monterey:       "6cd21192750835acdb39dfc5b2cebc8d68d35ffdfe466e671fef2bc5fd02f42c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47adf7634f505b0ae06e101b1d2128bc39572aa87d41f96ca5f17091d6305022"
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
